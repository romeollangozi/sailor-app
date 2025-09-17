//
//  GetEateriesConflictsUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

protocol GetEateryConflictsUseCaseProtocol {
    func execute(input: EateryConflictsInputModel) async throws -> EateryConflictsModel
}

final class GetEateryConflictsUseCase: GetEateryConflictsUseCaseProtocol {
    private let eateryConflictRepository: EateryConflictRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let eateriesListRepository: EateriesListRepositoryProtocol
	private let sailorsRepository: SailorsRepositoryProtocol
    
    init(eateryConflictRepository: EateryConflictRepositoryProtocol = EateryConflictRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         eateriesListRepository: EateriesListRepositoryProtocol = EateriesListRepository(),
		 sailorsRepository: SailorsRepositoryProtocol = SailorsRepository()
    ) {
        self.eateryConflictRepository = eateryConflictRepository
        self.currentSailorManager = currentSailorManager
        self.eateriesListRepository = eateriesListRepository
		self.sailorsRepository = sailorsRepository
    }
    
    func execute(input: EateryConflictsInputModel) async throws -> EateryConflictsModel {
        let conflictResponse = try await getConflicts(input: input)
        
        if(conflictResponse.type.isEmpty) {
            return EateryConflictsModel.none
        }
        
        let conflictType = EateryConflictType(rawValue: conflictResponse.type) ?? EateryConflictType.hard
        
        if(conflictType == EateryConflictType.hard) {
            return createHardConflict(conflictResponse: conflictResponse, input: input)
        } else if(conflictType == EateryConflictType.repeatConflict) {
            return try await createRepeatConflict(conflictResponse: conflictResponse, input: input)
		} else if(conflictType == EateryConflictType.soft) {
			return try await createSoftConflict(conflictResponse: conflictResponse, input: input)
		}
        
        return try await createSwapConflict(conflictResponse: conflictResponse, input: input)
    }
    
    private func getConflicts(input: EateryConflictsInputModel) async throws -> EateryConflicts {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        let request = EateryConflictsInput(personDetails: input.personDetails.map({
            item in .init(personId: item.personId)
        }),
                                           activityCode: input.activityCode,
                                           shipCode: currentSailor.shipCode,
                                           activitySlotCode: input.activitySlotCode,
                                           startDateTime: input.startDateTime.toISO8601(),
                                           endDateTime: "",
                                           activityGroupCode: "RT",
                                           isActivityPaid: false,
                                           bookingType: input.mealPeriod == .dinner ? "DN" : "BR",
                                           bookingLinkIds: [],
                                           embarkDate: currentSailor.embarkDate,
                                           debarkDate: currentSailor.debarkDate)
        
        guard let conflictResponse = try await eateryConflictRepository.getConflicts(input: request)  else { throw VVDomainError.genericError }
        
        return conflictResponse
    }
    
    private func createHardConflict(conflictResponse: EateryConflicts, input: EateryConflictsInputModel) -> EateryConflictsModel {
        let personDetails = conflictResponse.details.personDetails.map({
            x in EateryConflictsModel.PersonDetail(personId: x.personId, count: x.count)
        })
		
        let conflictDetails: EateryConflictsModel.ConflictDetails? = .init(title: "One or more of your party already has a dinner reservation on \(input.startDateTime.weekdayName())",
                                                                           description: "You can only book one restaurant per night. We limit bookings so all our sailors have a chance to eat everywhere.",
                                                                           isSwap: false,
                                                                           isClash: true,
																		   isSoftClash: false,
                                                                           personDetails: personDetails)
        
        return EateryConflictsModel(conflict: conflictDetails)
    }
    
	private func createRepeatConflict(conflictResponse: EateryConflicts, input: EateryConflictsInputModel) async throws -> EateryConflictsModel {

		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let personDetails = conflictResponse.details.personDetails.map({
            x in EateryConflictsModel.PersonDetail(personId: x.personId, count: x.count)
        })
		
		guard let eateriesList = try await eateriesListRepository.fetchEateries(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, shipName: currentSailor.shipName, reservationNumber: currentSailor.reservationNumber, includePortsName: false, useCache: true) else { throw VVDomainError.genericError }

		let eatery = eateriesList.findBookableEatery(byExternalId: input.activityCode)
		
		let itineraryLength = currentSailor.itineraryDays.count
		
		let title = itineraryLength <= 6
		? "One or more of your party already has a dinner reservation at \(eatery?.name ?? "")"
		: "One or more of your party already has 2 dinner reservations at \(eatery?.name ?? "")"
		
		let conflictDetails: EateryConflictsModel.ConflictDetails? = .init(title: title,
                                                                           description: "We limit bookings so all our sailors have a chance to eat everywhere. \n \nHowever it doesn’t mean you can’t eat at \(eatery?.name ?? "") again. We always reserve some walkins, so you can pop by and see if we have a table spare.",
                                                                           isSwap: false,
                                                                           isClash: true,
																		   isSoftClash: false,
                                                                           personDetails: personDetails)
        
        return EateryConflictsModel(conflict: conflictDetails)
    }
	
	private func createSoftConflict(conflictResponse: EateryConflicts, input: EateryConflictsInputModel) async throws -> EateryConflictsModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let personDetails = conflictResponse.details.personDetails.map({
			EateryConflictsModel.PersonDetail(personId: $0.personId, count: $0.count)
		})
		
		var description = ""
		if personDetails.count == 1 && personDetails.first?.personId == currentSailor.reservationGuestId {
			description = "You are double booked at this time—you can proceed, but you may not be able to be in two places at once."
		} else {
			let sailors = try await sailorsRepository.fetchMySailors(reservationGuestId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, useCache: true)
			let personIds = personDetails.map { $0.personId }
			let conflictSailorNames = sailors.filter { personIds.contains($0.reservationGuestId) }
				.map { $0.reservationGuestId == currentSailor.reservationGuestId ? "You" : $0.name }
				.joined(separator: ", ")
			let verb = conflictSailorNames.contains(",") ? "are" : "is"
			description = "\(conflictSailorNames) \(verb) double booked at this time—you can proceed, but they may not be able to be in two places at once."
		}
		
		let conflictDetails: EateryConflictsModel.ConflictDetails? = .init(title: "One or more of your party already is booked",
																		   description: description,
																		   isSwap: false,
																		   isClash: true,
																		   isSoftClash: true,
																		   personDetails: personDetails)
		
		return EateryConflictsModel(conflict: conflictDetails)
	}
    
    private func createSwapConflict(conflictResponse: EateryConflicts, input: EateryConflictsInputModel) async throws -> EateryConflictsModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        let conflictType = EateryConflictType(rawValue: conflictResponse.type) ?? EateryConflictType.swapSameRestaurantByDay
        
        let personDetails = conflictResponse.details.personDetails.map({
            x in EateryConflictsModel.PersonDetail(personId: x.personId, count: x.count)
        })
        
		guard let eateriesList = try await eateriesListRepository.fetchEateries(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, shipName: currentSailor.shipName, reservationNumber: currentSailor.reservationNumber, includePortsName: false, useCache: true) else { throw VVDomainError.genericError }
        
        let eateryToCancel = eateriesList.findBookableEatery(byExternalId: conflictResponse.details.cancellableRestaurantExternalId!)
        let eateryToSwap = eateriesList.findBookableEatery(byExternalId: conflictResponse.details.swappableRestaurantExternalId!)
		
        let title: String = conflictType == .swapDifferentRestaurantSameDay
			? "Your party already has a dinner reservation on \(input.startDateTime.weekdayName())"
            : "Your party already has a dinner reservation for \(eateryToCancel?.name ?? "")"
		
		let description = conflictType == .swapDifferentRestaurantSameDay
		 ? "You can only book one restaurant per night"
		 : "You can only book dinner once per restaurant per voyage"
        
		let conflictDetails: EateryConflictsModel.ConflictDetails? = .init(title: title, description: description, isSwap: true, isClash: false, isSoftClash: false, personDetails: personDetails, swapConflictDetails: .init(
            cancellableRestaurantExternalId: eateryToCancel!.externalId,
            cancellableRestaurantName: eateryToCancel!.name,
            cancellableAppointmentDateTime:  conflictResponse.details.cancellableAppointmentDateTime?.toFullDateTimeWithOrdinal() ?? "",
            cancellableBookingLinkId: conflictResponse.details.cancellableBookingLinkId!,
            swappableRestaurantExternalId: eateryToSwap!.externalId,
            swappableRestaurantName: eateryToSwap!.name,
            swappableAppointmentDateTime: conflictResponse.details.swappableAppointmentDateTime?.toFullDateTimeWithOrdinal() ?? ""))
        
        return EateryConflictsModel(conflict: conflictDetails)
    }
}

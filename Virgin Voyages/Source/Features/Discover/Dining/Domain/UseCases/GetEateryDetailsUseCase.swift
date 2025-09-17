//
//  GetEateryDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//

protocol GetEateryDetailsUseCaseProtocol {
	func execute(slug: String, useCache: Bool) async throws -> EateryDetailsModel
}

final class GetEateryDetailsUseCase : GetEateryDetailsUseCaseProtocol {
	private let eateryDetailsRepositoryProtocol: EateryDetailsRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let eateriesListRepository: EateriesListRepositoryProtocol
	
	init(eateryDetailsRepositoryProtocol: EateryDetailsRepositoryProtocol = EateryDetailsRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 activitiesGuestRepository: ActivitiesGuestRepositoryProtocol = ActivitiesGuestRepository(),
		 eateriesListRepository: EateriesListRepositoryProtocol = EateriesListRepository()) {
		self.eateryDetailsRepositoryProtocol = eateryDetailsRepositoryProtocol
		self.currentSailorManager = currentSailorManager
		self.eateriesListRepository = eateriesListRepository
	}
	
	func execute(slug: String, useCache: Bool) async throws -> EateryDetailsModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let eateryDetails = try await eateryDetailsRepositoryProtocol.fetchEateryDetails(slug: slug,
																						  reservationId: currentSailor.reservationId,
																						  reservationGuestId: currentSailor.reservationGuestId,
																						  shipCode: currentSailor.shipCode,
																						  useCache: useCache) else { throw VVDomainError.genericError }
		
		guard let eateriesList = try await eateriesListRepository.fetchEateries(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, shipName: currentSailor.shipName, reservationNumber: currentSailor.reservationNumber, includePortsName: false) else { throw VVDomainError.genericError }
		
		guard let eatery = eateriesList.findEatery(byExternalId: eateryDetails.externalId) else { throw VVDomainError.genericError }
		
		return EateryDetailsModel(name: eateryDetails.name,
								  deckLocation: eateryDetails.deckLocation,
								  portraitHeroURL: eateryDetails.portraitHeroURL,
								  externalId: eateryDetails.externalId,
								  venueId: eatery.venueId,
								  introduction: eateryDetails.introduction,
								  longDescription: eateryDetails.longDescription,
								  needToKnows: eateryDetails.needToKnows,
                                  editorialBlocks: eateryDetails.editorialBlocks,
								  openingTimes: eateryDetails.openingTimes.map({ x in .init(label: x.label, text: x.text)}),
								  isBookable: eatery.isBookable,
								  leadTime: eateriesList.leadTime,
								  preVoyageBookingStoppedInfo: eateriesList.preVoyageBookingStoppedInfo,
                                  menuData: MenuData(menuFooterColor: eateryDetails.menuData.menuFooterColor, description: eateryDetails.menuData.description, menuTextColor: eateryDetails.menuData.menuTextColor, coverDescription: eateryDetails.menuData.coverDescription, pageBackground: eateryDetails.menuData.pageBackground, coverImage: eateryDetails.menuData.coverImage, name: eateryDetails.menuData.name, header: eateryDetails.menuData.header, logo: eateryDetails.menuData.logo, id: eateryDetails.menuData.id, menuPdf: eateryDetails.menuData.menuPdf),
                                  resources: eateriesList.resources
		)
	}
}

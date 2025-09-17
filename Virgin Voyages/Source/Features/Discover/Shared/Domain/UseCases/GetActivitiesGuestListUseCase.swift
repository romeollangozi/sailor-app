//
//  GetActivitiesGuestListUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/14/24.
//

protocol GetActivitiesGuestListUseCaseProtocol {
    func execute() async  -> Result<[ActivitiesGuest], VVDomainError>
    
    func executeV2() async throws -> [ActivitiesGuest]
}

class GetActivitiesGuestListUseCase : GetActivitiesGuestListUseCaseProtocol {

	private var currentSailorManager: CurrentSailorManagerProtocol
	private var activitiesGuestRepository: ActivitiesGuestRepositoryProtocol

	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 activitiesGuestRepository: ActivitiesGuestRepositoryProtocol = ActivitiesGuestRepository()) {
		self.currentSailorManager = currentSailorManager
		self.activitiesGuestRepository = activitiesGuestRepository
	}

    func execute() async  -> Result<[ActivitiesGuest], VVDomainError> {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return .failure(.unauthorized)
		}

		let activitiesGuestList = await activitiesGuestRepository.fetchActivitiesGuestList()

		switch activitiesGuestList {
		case .success(let activitiesGuestList):
            let prioritizedGuestList = prioritizedGuestList(withId: currentSailor.guestId, in: activitiesGuestList)
			return .success(prioritizedGuestList)
		case .failure(let error):
			return .failure(error)
		}
	}

	func prioritizedGuestList(withId targetId: String, in activitiesGuestList: [ActivitiesGuest]) -> [ActivitiesGuest] {
		return activitiesGuestList.sorted { $0.guestId == targetId && $1.guestId != targetId }
	}
    
    func executeV2() async throws -> [ActivitiesGuest] {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        return (try await activitiesGuestRepository
            .fetchActivitiesGuestListV2(reservationGuestId: currentSailor.reservationGuestId))
            .prioritizedGuestList(withId: currentSailor.guestId)
            .makeCurrectSailorCabinMateWithSelf(reservationGuestId: currentSailor.reservationGuestId)
    }
}

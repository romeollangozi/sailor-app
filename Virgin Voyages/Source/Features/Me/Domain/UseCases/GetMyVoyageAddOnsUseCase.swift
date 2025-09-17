//
//  GetMyVoyageAddOnsUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

protocol GetMyVoyageAddOnsUseCaseProtocol {
	func execute(useCache: Bool) async throws -> MyVoyageAddOns
}

final class GetMyVoyageAddOnsUseCase: GetMyVoyageAddOnsUseCaseProtocol {

	private let currentSailorManager: CurrentSailorManagerProtocol
	private let myVoyageAddOnsRepository: MyVoyageAddOnsRepositoryProtocol

	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 myVoyageAddOnsRepository: MyVoyageAddOnsRepositoryProtocol = MyVoyageAddOnsRepository()) {
		self.currentSailorManager = currentSailorManager
		self.myVoyageAddOnsRepository = myVoyageAddOnsRepository
	}

	func execute(useCache: Bool = false) async throws -> MyVoyageAddOns {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
		guard let response = try await myVoyageAddOnsRepository.fetchMyVoyageAddOns(
            reservationNumber: currentSailor.reservationNumber,
            shipCode: currentSailor.shipCode,
			guestId: currentSailor.guestId,
			useCache: useCache
        ) else {
			throw VVDomainError.genericError
		}
		return response
	}
}

//
//  GetMySailorsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 19.2.25.
//

protocol GetMySailorsUseCaseProtocol {
	func execute(useCache: Bool, appointmentLinkId: String?) async throws -> [SailorModel]
}

extension GetMySailorsUseCaseProtocol {
	func execute(useCache: Bool) async throws -> [SailorModel] {
		return try await execute(useCache: useCache, appointmentLinkId: nil)
	}
}

final class GetMySailorsUseCase: GetMySailorsUseCaseProtocol {
	private let sailorsRepository: SailorsRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(sailorsRepository: SailorsRepositoryProtocol = SailorsRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.sailorsRepository = sailorsRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(useCache: Bool, appointmentLinkId: String?) async throws -> [SailorModel] {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		return try await sailorsRepository.fetchMySailors(reservationGuestId: currentSailor.reservationGuestId,
														  reservationNumber: currentSailor.reservationNumber,
														  useCache: useCache,
														  appointmentLinkId: appointmentLinkId)
	}
}

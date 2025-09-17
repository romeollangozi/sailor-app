//
//  GetMyAgendaUseCaseProtocol.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 5.3.25.
//

import Foundation

protocol  GetMyVoyageAgendaUseCaseProtocol {
    func execute(useCache: Bool) async throws -> MyVoyageAgenda
}

final class GetMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol {

    private let myVoyageAgendaRepository: MyVoyageAgendaRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(myVoyageAgendaRepository: MyVoyageAgendaRepositoryProtocol = MyVoyageAgendaRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.myVoyageAgendaRepository = myVoyageAgendaRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(useCache: Bool = false) async throws -> MyVoyageAgenda {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let result = try await myVoyageAgendaRepository.fetchMyVoyageAgenda(shipCode: currentSailor.shipCode, reservationGuestId: currentSailor.reservationGuestId, useCache: useCache)
        return MyVoyageAgenda(title: result.title, appointments: result.appointments, emptyStateText: result.emptyStateText, emptyStatePictogramUrl: result.emptyStatePictogramUrl)
    }
}

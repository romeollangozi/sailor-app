//
//  GetHomeRTSDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 19.3.25.
//

import Foundation


protocol GetHomeRTSDetailsUseCaseProtocol {
    func execute() async throws -> TaskDetail?
}

class GetHomeRTSDetailsUseCase: GetHomeRTSDetailsUseCaseProtocol {
    private let dashboardLandingRepository: DashboardLandingRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    

    init(dashboardLandingRepository: DashboardLandingRepositoryProtocol = DashboardLandingMemoryCachingRepository.shared,
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.dashboardLandingRepository = dashboardLandingRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute() async throws -> TaskDetail? {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        guard let dashboardLanding = await dashboardLandingRepository.fetchDashboardLanding(
            reservationNumber: currentSailor.reservationNumber,
            guestId: currentSailor.reservationGuestId) else {
            
            return nil
        }
        
        if let rts = dashboardLanding.taskList?.tasksDetail?.first(where: { taskDetails in
            taskDetails.moduleKey == "ReadyToSail"
        }) {
            return rts
        }

        return nil
    }
}



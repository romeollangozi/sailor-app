//
//  DeleteOneNotificationUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 8/1/25.
//

import Foundation

protocol DeleteOneNotificationUseCaseProtocol {
    func execute(notificationId: String) async throws
}

final class DeleteOneNotificationUseCase: DeleteOneNotificationUseCaseProtocol {
    
    private let statusBannersNotificationsRepositoryProtocol: StatusBannersNotificationsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(statusBannersNotificationsRepositoryProtocol: StatusBannersNotificationsRepositoryProtocol = StatusBannersNotificationsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.statusBannersNotificationsRepositoryProtocol = statusBannersNotificationsRepositoryProtocol
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(notificationId: String) async throws {
        
        guard let currentSailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }
        
        let voyageNumber = currentSailor.voyageNumber
        
        guard let _ = try await statusBannersNotificationsRepositoryProtocol.deleteOneNotification(notificationId: notificationId,
                                                                                                   voyageNumber: voyageNumber) else {
            throw VVDomainError.genericError
        }
    }
    
}

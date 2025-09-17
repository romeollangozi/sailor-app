//
//  ClearAllNotificationsViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import SwiftUI

@Observable
class ClearAllNotificationsViewModel: BaseViewModel, ClearAllNotificationsViewModelProtocol {
   
    private let deleteAllNotificationsUseCase: DeleteAllNotificationsUseCaseProtocol
    var appCoordinator: AppCoordinator = .shared
    var screenState: ScreenState = .loading
    private let notificationsEventsNotificationService: NotificationsEventNotificationServiceProtocol
    
    init(deleteAllNotificationsUseCase: DeleteAllNotificationsUseCaseProtocol = DeleteAllNotificationsUseCase(), notificationsEventsNotificationService: NotificationsEventNotificationServiceProtocol = NotificationsEventNotificationService.shared) {
        self.deleteAllNotificationsUseCase = deleteAllNotificationsUseCase
        self.notificationsEventsNotificationService = notificationsEventsNotificationService
    }
    
    func clearAllNotifications(completion: @escaping () -> Void) {
        Task{
            await self.deleteAllNotifications(completion: completion)
        }
    }
    
    func dismissClearAllPopup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.appCoordinator.executeCommand(NotificationsCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .clearAllPopup))
        }
    }
    
    private func deleteAllNotifications(completion: @escaping () -> Void) async {
        if let _ = await executeUseCase({
            try await self.deleteAllNotificationsUseCase.execute()
        }) {
            completion()
        }
        await executeOnMain({
            self.dismissClearAllPopup()
        })
    }
    
}

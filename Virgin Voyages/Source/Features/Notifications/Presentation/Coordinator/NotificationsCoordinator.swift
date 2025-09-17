//
//  NotificationsCoordinator.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import Foundation

enum NotificationsFullScreenRoute: BaseFullScreenRoute {
    case clearAllPopup
    var id: String {
        switch self {
        case .clearAllPopup:
            return "clearAllPopup"
        }
    }
}

@Observable class NotificationsCoordinator {
    var fullScreenOverlayRouter: NotificationsFullScreenRoute?
    
    init(fullScreenOverlayRouter: NotificationsFullScreenRoute? = nil) {
        self.fullScreenOverlayRouter = fullScreenOverlayRouter
    }
}

extension NotificationsCoordinator{
    struct ShowClearAllNotificationsFullScreenCommand: NavigationCommandProtocol{
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.notificationsCoordinator.fullScreenOverlayRouter = .clearAllPopup
        }
    }
    
    struct DismissFullScreenOverlayCommand: NavigationCommandProtocol {
        let pathToDismiss: NotificationsFullScreenRoute
        
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.notificationsCoordinator.fullScreenOverlayRouter == pathToDismiss {
                coordinator.homeTabBarCoordinator.notificationsCoordinator.fullScreenOverlayRouter = nil
            }
        }
    }
}

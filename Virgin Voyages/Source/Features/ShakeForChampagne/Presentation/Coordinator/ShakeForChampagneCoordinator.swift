//
//  ShakeForChampagneCoordinator.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/26/25.
//

import Foundation

enum ShakeForChampagneFullScreenOverlayRoute: BaseFullScreenRoute {
    
    case error
    
    var id: String {
        switch self {
        case .error:
            return "error"
        }
    }
}

@Observable class ShakeForChampagneCoordinator {
    
    // MARK: - Routers
    var fullScreenRouter: ShakeForChampagneFullScreenOverlayRoute?
    
    // MARK: - Init
    init(fullScreenRouter: ShakeForChampagneFullScreenOverlayRoute? = nil) {
        self.fullScreenRouter = fullScreenRouter
    }
    
}

// MARK: - Commands

extension ShakeForChampagneCoordinator {
    
    struct DismissFullScreenOverlayCommand: NavigationCommandProtocol {
        let pathToDismiss: ShakeForChampagneFullScreenOverlayRoute
        
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.shakeForChampagneCoordinator.fullScreenRouter == pathToDismiss
            {
                coordinator.homeTabBarCoordinator.shakeForChampagneCoordinator.fullScreenRouter = nil
            }
        }
    }

    struct OpenShipSpaceScreenCommand: NavigationCommandProtocol {
        let shipSpaceCode: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .dashboard
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shipSpace(shipSpaceCode))
        }
    }
    
}

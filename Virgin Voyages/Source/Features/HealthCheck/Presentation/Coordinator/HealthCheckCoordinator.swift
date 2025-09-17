//
//  HealthCheckCoordinator.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/4/25.
//

import SwiftUI
import Foundation

enum HealthCheckRoute: BaseNavigationRoute {
    case healthCheckQuestion(detail: HealthCheckDetail)
}

@Observable class HealthCheckCoordinator {
    
    var navigationRouter: NavigationRouter<HealthCheckRoute>
    
    init(navigationRouter: NavigationRouter<HealthCheckRoute> = .init()) {
        self.navigationRouter = navigationRouter
    }
}

extension HealthCheckCoordinator {
    
    struct NavigateBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.healthCheckCoordinator.navigationRouter.navigateBack()
        }
    }
    
    struct OpenHealthQuestion: NavigationCommandProtocol {
        
        let healthCheckDetail: HealthCheckDetail
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.healthCheckCoordinator.navigationRouter.navigateTo(.healthCheckQuestion(detail: healthCheckDetail))
        }
    }
    
}

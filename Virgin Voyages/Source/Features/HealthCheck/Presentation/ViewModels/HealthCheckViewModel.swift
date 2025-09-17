//
//  HealthCheckViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/4/25.
//

import SwiftUI
import VVUIKit

@MainActor
@Observable class HealthCheckViewModel {
    
    var navigationPath: NavigationPath {
        get {
            return navigationRouter.navigationPath
        }
        set {
            navigationRouter.navigationPath = newValue
        }
    }
    
    private var navigationRouter: NavigationRouter<HealthCheckRoute> {
        return AppCoordinator.shared.homeTabBarCoordinator.healthCheckCoordinator.navigationRouter
    }
    
    func goToRoot() {
        navigationRouter.goToRoot()
    }
    
}

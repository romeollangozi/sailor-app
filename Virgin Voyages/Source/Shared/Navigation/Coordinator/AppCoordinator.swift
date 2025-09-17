//
//  AppCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 15.1.25.
//

import Foundation
import SwiftUI

protocol NavigationCommandProtocol {
    func execute(on coordinator: AppCoordinator)
}

protocol CoordinatorProtocol {
    
    // MARK: Dependencies
    var authenticationService: AuthenticationServiceProtocol { get }
    var currentSailorManager: CurrentSailorManagerProtocol { get }
    
    // MARK: State properties
    var currentFlow: ApplicationFlow { get }
    
    // MARK: Functions
    func calculateCurrentScreenFlow()
    
    // MARK: Sub-Coordinators
	var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator { get set }
    var landingScreenCoordinator: LandingScreensCoordinator { get set }
	var discoverCoordinator: DiscoverCoordinator { get set }
    var homeTabBarCoordinator: HomeTabBarCoordinator { get set }
    func executeCommand(_ command: NavigationCommandProtocol)
}

protocol CoordinatorNavitationDestinationViewProvider {
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView
}

protocol CoordinatorSheetViewProvider {
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView
}

protocol CoordinatorFullScreenViewProvider {
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView
}

@Observable
class AppCoordinator: CoordinatorProtocol {

    // Shared Instance
    static let shared = AppCoordinator()

    //MARK: Sub-Coordinators
	var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator
    var landingScreenCoordinator: LandingScreensCoordinator
    var homeTabBarCoordinator: HomeTabBarCoordinator

    // TODO: Need to move inside the home tab bar coordinator.
	var discoverCoordinator: DiscoverCoordinator

    /// var currentFlow
    /// Controls which application screen flow should be presented
    var currentFlow: ApplicationFlow = .initialLoading
    
    
    // MARK: Dependencies
    //  var authenticationService
    /// Injected into AppCoordinator to calculate current user state and present the required scren flow accordingly.
    /// Currently contains also the voyage/reservation state; In future we will probably have something like ReservationService to get the reservation state.
    internal var authenticationService: AuthenticationServiceProtocol
    
    //  var currentSailorManager
    /// For getting
    internal var currentSailorManager: CurrentSailorManagerProtocol

    
    // MARK: Init
    init(authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator = .init(),
		 landingScreenCoordinator: LandingScreensCoordinator = .init(),
         homeTabBarCoordinator: HomeTabBarCoordinator = .init(selectedTab: .dashboard),
		 discoverCoordinator: DiscoverCoordinator = .init()
    ) {
        // Dependendencies
        self.authenticationService = authenticationService
        self.currentSailorManager = currentSailorManager
        
        // Child coordinators
		self.offlineModeLandingScreenCoordinator = offlineModeLandingScreenCoordinator
        self.landingScreenCoordinator = landingScreenCoordinator
        self.homeTabBarCoordinator = homeTabBarCoordinator
        self.discoverCoordinator = discoverCoordinator
    }

    // MARK: Execute Navigation Command
    // This can be used on other/child coordinators. where
    func executeCommand(_ command: NavigationCommandProtocol) {
        command.execute(on: self)
    }
    
    
    func getAuthenticationService() -> AuthenticationServiceProtocol {
        return self.authenticationService
    }
    
    func getCurrentSailorManager() -> CurrentSailorManagerProtocol {
        return self.currentSailorManager
    }
}


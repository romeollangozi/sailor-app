//
//  OfflineModeHomeLandingScreenCoordinator.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/7/25.
//

import Foundation

enum OfflineModeHomeLandingNavigationRoute: BaseNavigationRoute {
	case agenda
	case eventLineUp
}

@Observable class OfflineModeHomeLandingScreenCoordinator {
	var navigationRouter: NavigationRouter<OfflineModeHomeLandingNavigationRoute>

	init(navigationRouter: NavigationRouter<OfflineModeHomeLandingNavigationRoute> = .init()) {
		self.navigationRouter = navigationRouter
	}
}

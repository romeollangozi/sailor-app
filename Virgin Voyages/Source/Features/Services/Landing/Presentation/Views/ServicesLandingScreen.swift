//
//  ServicesLandingScreen.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/22/25.
//

import SwiftUI

protocol ServicesLandingScreenViewModelProtocol: CoordinatorNavitationDestinationViewProvider {
	var appCoordinator: AppCoordinator { get set }
    func goToRoot()
}

struct ServicesLandingScreen: View {
	
	@State private var viewModel: ServicesLandingScreenViewModelProtocol
	
	init(viewModel: ServicesLandingScreenViewModelProtocol = ServicesLandingScreenViewModel()) {
		self._viewModel = State(wrappedValue: viewModel)
	}
	
	var body: some View {
		
		NavigationStack(path: $viewModel.appCoordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigationPath) {
			
			ServicesScreen()
				.navigationDestination(for: ServiceNavigationRoute.self) { route in
					viewModel.destinationView(for: route)
				}
		}
        .onAppear {
            viewModel.goToRoot()
        }
		
	}
}

#Preview {
	ServicesLandingScreen()
}

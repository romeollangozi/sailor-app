//
//  CancelledVoyageView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.8.25.
//

import SwiftUI
import VVUIKit

struct CancelledVoyageView: View {
	@State private var viewModel: CancelledVoyageViewModel

	init(viewModel: CancelledVoyageViewModel = CancelledVoyageViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		NavigationStack(path: $viewModel.appCoordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigationPath) {
			VVExceptionView(viewModel: CancelledVoyageExceptionViewModel())
				.navigationDestination(for: ClaimABookingNavigationRoute.self) { route in
					viewModel.destinationView(for: route)
				}
				.navigationBarBackButtonHidden(true)
		}
	}
}

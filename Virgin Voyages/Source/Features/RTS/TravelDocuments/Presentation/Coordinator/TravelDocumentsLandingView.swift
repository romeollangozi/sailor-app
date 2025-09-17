//
//  TravelDocumentsLandingView.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.2.25.
//

import SwiftUI

struct TravelDocumentsLandingView: View {
    @State var viewModel: TravelDocumentsViewModel
    let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        self.viewModel = TravelDocumentsViewModel(onDismiss: onDismiss)
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            CitizenshipCheckScreen()
            .navigationDestination(for: TravelDocumentsRoute.self) { route in
                viewModel.destinationView(for: route)
            }
            .fullScreenCover(item: $viewModel.fullScreenRouter) { path in
                viewModel.destinationView(for: path)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }

}

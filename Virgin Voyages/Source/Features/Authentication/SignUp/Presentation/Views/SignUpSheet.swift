//
//  SignUpSheet.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import SwiftUI
import AuthenticationServices

extension SignUpSheet {
    static func create() -> SignUpSheet {
        return SignUpSheet(viewModel: SignUpSheetViewModel())
    }
}

protocol SignUpSheetViewModelProtocol: CoordinatorNavitationDestinationViewProvider {
    var appCoordinator: CoordinatorProtocol { get set }
    func dismiss()
}


struct SignUpSheet: View {

    @State var viewModel: SignUpSheetViewModelProtocol

    // MARK: - Init
    init(viewModel: SignUpSheetViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $viewModel.appCoordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigationPath) {
            SignUpLandingView(viewModel: SignUpLandingViewModel())
                .navigationDestination(for: SignupNavigationRoute.self) { route in
                    viewModel.destinationView(for: route)
                }
                .navigationBarBackButtonHidden(true)
        }
    }
}

//
//  LoginSheet.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/2/24.
//

import SwiftUI
import AuthenticationServices


extension LoginSheet {
    static func create() -> LoginSheet {
        return LoginSheet(viewModel: LoginSheetViewModel())
    }
}

struct LoginSheet: View {
    
    @State var viewModel: LoginSheetViewModelProtocol
    
    init(viewModel: LoginSheetViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
		NavigationStack(path: $viewModel.navigationCoordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigationPath) {
            LoginSelectionView()
                .navigationDestination(for: LoginNavigationRoute.self) { route in
                    destinationView(for: route)
                }
                .navigationBarBackButtonHidden(true)
        }
        .fullScreenCover(item: $viewModel.navigationCoordinator.landingScreenCoordinator.loginCoordinator.fullScreenRouter, onDismiss: {
            viewModel.dismissFullScreenModal()
        }) { route in
			destinationView(for: route)
        }
    }

	@ViewBuilder func destinationView(for loginNavigationRoute: LoginNavigationRoute) -> some View {
		switch loginNavigationRoute {
		case .landingScreen:
			LoginSelectionView()
		case .loginWithEmail:
			EmailLoginView.create()
				.navigationBarBackButtonHidden(true)
		case .loginWithBookinReference:
			BookingReferenceLoginView.create()
				.navigationBarBackButtonHidden(true)
		case .forgotPassword:
			RequestNewPasswordView.create()
			.navigationBarBackButtonHidden(true)
		case .newPasswordRequested:
			NewPasswordRequestedView.create()
			.navigationBarBackButtonHidden(true)
		case .emailNotRecognised:
			EmailNotRecognisedView.create()
			.navigationBarBackButtonHidden(true)
		case .socialProfileView(model: let model):
			SocialProfileView.create(viewModel: SocialProfileViewModel(signUpInputModel: model), isSocialSignup: true)
				.navigationBarBackButtonHidden(true)
		case .loginWithTwin(guestDetails: let guests, let sailDate, let cabinNumber):
			LoginTwinView.create(guestDetails: guests, sailDate: sailDate, cabinNumber: cabinNumber)
				.navigationBarBackButtonHidden(true)
		}
	}

	// MARK: Coordinator Full Screen Destination View
	@ViewBuilder func destinationView(for fullScreenRoute: LoginFullScreenViewRoute) -> some View {
		switch fullScreenRoute {
		case .loginErrorModal(errorModalType: let type):
			self.loginErrorSheetModal(type)
		case .loginWithSocialErrorModal(let errorMessage):
			loginWithSocialErrorSheetModal(errorMessage: errorMessage)
		}
	}


	// MARK: Full Screen Modal Views
	private func loginErrorSheetModal(_ loginErrorModal: LoginErrorModalType) -> some View {

		var subheadlineText = ""
		var secondaryButtonText: String? = nil

		switch loginErrorModal {
		case .ship:
			subheadlineText = "Sorry sailor we can't seem to log you in with those details, please check and try again.\n\nIf you keep having problems, come and see us at the Help Desk at the Roundabout on Deck 7"
		case .shore:
			subheadlineText = "Sorry sailor we can't seem to log you in with those details, please check and try again.\n\nIf you keep having problems, you can Sign-up or Login with a email address and password"
			secondaryButtonText = "Login using a different method"
		case .none: break
		}

		return ErrorSheetModal(title: "#Awkward",
								subheadline: subheadlineText,
								primaryButtonText: "Try Again",
								secondaryButtonText: secondaryButtonText,
						primaryButtonAction: {
			viewModel.dismissFullScreenModal()
		}, secondaryButtonAction: {
			viewModel.dismissErrorModalAndGoBack()
		}, dismiss: {
			viewModel.dismissFullScreenModal()
		})
		.presentationBackground(Color.black.opacity(0.75))
	}

	private func loginWithSocialErrorSheetModal(errorMessage: String) -> some View {
		ErrorSheetModal(title: "#Awkward",
						subheadline: "\(errorMessage)\n\nUnfortunately we can't log you in with your social details right now.\n\nYou can login with your email address and password or try again a bit later.",
						primaryButtonText: "Try Again",
						secondaryButtonText: "Login using a different method",
						primaryButtonAction: {
			viewModel.dismissFullScreenModal()
		}, secondaryButtonAction: {
			viewModel.dismissFullScreenModal()
		}, dismiss: {
			viewModel.dismissFullScreenModal()
		})
		.presentationBackground(Color.black.opacity(0.75))
	}
}


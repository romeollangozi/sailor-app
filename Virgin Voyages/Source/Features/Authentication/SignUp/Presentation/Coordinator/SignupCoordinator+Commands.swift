//
//  SignupCoordinator+Commands.swift
//  Virgin Voyages
//
//  Created by TX on 21.1.25.
//

import Foundation


extension SignupCoordinator {
	struct OpenSignUpWithEmailCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateTo(.email)
		}
	}

	struct OpenSignupDetailsCommand: NavigationCommandProtocol {
		let email: String
		let receiveEmails: Bool

		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateTo(.details(email: email, receiveEmails: receiveEmails))
		}
	}

	struct OpenProtectYourAccountCommand: NavigationCommandProtocol {
		let signUpMethodModel: SignUpInputModel

		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateTo(.protectYourAccount(model: signUpMethodModel))
		}
	}

	struct OpenStrikePoseViewCommand: NavigationCommandProtocol {
		let signUpInputModel: SignUpInputModel

		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateTo(.signUpProfileImageView(model: signUpInputModel))
		}
	}

	struct OpenProfileImageViewCommand: NavigationCommandProtocol {
		let signUpInputModel: SignUpInputModel

		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateTo(.profilePhotoView(model: signUpInputModel))
		}
	}

	struct OpenSocialProfileViewCommand: NavigationCommandProtocol {
		let signUpInputModel: SignUpInputModel

		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateTo(.socialProfileView(model: signUpInputModel))
		}
	}

	struct DismissSignUpSheetCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.dismissCurrentSheet()
		}
	}

	struct DismissSignUpSheetWithoutAnimationCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.dismissCurrentSheetWithoutAnimation()
		}
	}

	struct GoBackCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.navigateBack()
		}
	}

	struct GoBackToRootViewCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.root()
		}
	}

}

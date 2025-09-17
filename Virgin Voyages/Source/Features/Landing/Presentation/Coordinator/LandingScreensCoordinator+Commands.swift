//
//  LandingScreensCoordinator+Commands.swift
//  Virgin Voyages
//
//  Created by TX on 16.1.25.
//

import Foundation

extension LandingScreensCoordinator {
 
    struct OpenLoginSelectionCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.sheetRouter.present(sheet: .login(.landingScreen))
        }
    }
    
    struct OpenSignUpCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.sheetRouter.present(sheet: .signup(.landingScreen))
        }
    }
    
    struct OpenClaimABookingDeactivatedAccountScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.sheetRouter.present(sheet: .claimABookingDeactivatedAccount)
        }
    }
    
    struct DismissCurrentSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.dismissCurrentSheet()
        }
    }

    struct DismissCurrentSheetAndOpenLoginCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.dismissCurrentSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                coordinator.landingScreenCoordinator.sheetRouter.present(sheet: .login(.landingScreen))
                coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.setupPaths(paths: [.loginWithEmail])
            }
        }
    }

	struct DismissCurrentSheetAndOpenSignUpCommand: NavigationCommandProtocol {
		let model: SignUpInputModel
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.dismissCurrentSheet()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
				coordinator.landingScreenCoordinator.sheetRouter.present(sheet: .signup(.signUpProfileImageView(model: model)))
				coordinator.landingScreenCoordinator.signupCoordinator.navigationRouter.setupPaths(paths: [ .landingScreen, .socialProfileView(model: model)])
			}
		}
	}

}


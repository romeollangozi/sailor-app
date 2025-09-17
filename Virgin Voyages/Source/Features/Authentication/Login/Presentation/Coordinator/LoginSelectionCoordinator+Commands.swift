//
//  LoginCoordinator+Commands.swift
//  Virgin Voyages
//
//  Created by TX on 20.1.25.
//

import Foundation

extension LoginSelectionCoordinator {
    struct OpenLoginWithEmailCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateTo(.loginWithEmail)
        }
    }
    
    struct OpenLoginWithBookingReferenceCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateTo(.loginWithBookinReference)
        }
    }
    
    struct OpenForgotPasswordCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateTo(.forgotPassword)
        }
    }
    
    struct OpenEmailNotRecognisedCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateTo(.emailNotRecognised)
        }
    }
    
    struct OpenNewPasswordRequestedCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateTo(.newPasswordRequested)
        }
    }
    
    struct OpenLoginWithTwin: NavigationCommandProtocol {
        let guestDetails: [LoginGuestDetails]
        let sailDate: Date?
        let cabinNumber: String?
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateTo(.loginWithTwin(guestDetails: guestDetails, sailDate: sailDate, cabinNumber: cabinNumber))
        }
    }
    
        
    struct GoBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.navigateBack()
        }
    }
    
    struct GoBackToRootViewCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.goToRoot()
        }
    }
    
    struct DismissAndResetNavigationStateCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.dismissCurrentSheetWithoutAnimation()
        }
    }
    
    struct DismissFullScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.fullScreenRouter = nil
        }
    }
    
    struct ShowFullScreenLoginWithBookingReferenceError: NavigationCommandProtocol {
        let errorModalType: LoginErrorModalType
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.fullScreenRouter = .loginErrorModal(errorModalType: errorModalType)
        }
    }
    
    struct ShowErrorWithSocialLoginFullCoverSheet: NavigationCommandProtocol {
        
        let errorMessage: String
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.fullScreenRouter = .loginWithSocialErrorModal(errorMessage: errorMessage)
        }
    }
    
    struct DismissErrorModalAndGoBack: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.loginCoordinator.fullScreenRouter = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                // Pop navigation view with a short animation delay
                coordinator.landingScreenCoordinator.loginCoordinator.navigationRouter.goToRoot()
            }
        }
    }
    
}

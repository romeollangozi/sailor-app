//
//  LoginSheetCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 20.1.25.
//

import Foundation
import SwiftUI

enum LoginNavigationRoute: BaseNavigationRoute {
    case landingScreen
    case loginWithEmail
    case loginWithBookinReference
    case forgotPassword
    case newPasswordRequested
    case emailNotRecognised
    case socialProfileView(model: SignUpInputModel)
    case loginWithTwin(guestDetails: [LoginGuestDetails], sailDate: Date?, cabinNumber: String?)
}

enum LoginFullScreenViewRoute: BaseFullScreenRoute {
    case loginErrorModal(errorModalType: LoginErrorModalType)
    case loginWithSocialErrorModal(errorMessage: String)

    var id: String {
        switch self {
        case .loginErrorModal(let type) :
            return "loginErrorModal-\(type)"
        case .loginWithSocialErrorModal(_):
            return "loginWithSocialErrorModal"
        }
    }
}

@Observable class LoginSelectionCoordinator {
    var navigationRouter: NavigationRouter<LoginNavigationRoute>
    var fullScreenRouter: LoginFullScreenViewRoute?

    init(navigationRouter: NavigationRouter<LoginNavigationRoute> = .init(),
         fullScreenRouter: LoginFullScreenViewRoute? = nil) {
        self.navigationRouter = navigationRouter
        self.fullScreenRouter = fullScreenRouter
    }
}

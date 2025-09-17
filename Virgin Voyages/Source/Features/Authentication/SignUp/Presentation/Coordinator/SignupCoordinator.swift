//
//  SignupCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 20.1.25.
//

import Foundation


enum SignupNavigationRoute: BaseNavigationRoute {
    case landingScreen
    case email
    case details(email: String, receiveEmails: Bool)
    case protectYourAccount(model: SignUpInputModel)
    case signUpProfileImageView(model: SignUpInputModel)
    case profilePhotoView(model: SignUpInputModel)
    case socialProfileView(model: SignUpInputModel)
}

@Observable class SignupCoordinator {
    
    var navigationRouter: NavigationRouter<SignupNavigationRoute>

    init(navigationRouter: NavigationRouter<SignupNavigationRoute> = .init()) {
        self.navigationRouter = navigationRouter
    }
}

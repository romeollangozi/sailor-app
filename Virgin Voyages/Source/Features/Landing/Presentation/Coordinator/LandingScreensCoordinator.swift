//
//  AuthCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 15.1.25.
//

import Foundation
import SwiftUI

enum LandingSheetRoute: BaseSheetRouter {
    // Dashboard routes
    case login(LoginNavigationRoute)
    case signup(SignupNavigationRoute)
    case claimABookingDeactivatedAccount
    
    // This is the unique identifier for each route
    var id: String {
        switch self {
        case .login:
            return "login"
        case .signup:
            return "signup"
        case .claimABookingDeactivatedAccount:
            return "claimABooking"
        }
    }
}


@Observable class LandingScreensCoordinator {
    
    // MARK: Routers
    var sheetRouter: SheetRouter<LandingSheetRoute>

    // MARK: Child Coordinators
    var loginCoordinator: LoginSelectionCoordinator
    var signupCoordinator: SignupCoordinator
    var claimABookingCoordinator: ClaimABookingCoordinator
    
    init(
        sheetRouter: SheetRouter<LandingSheetRoute> = .init(),
        loginCoordinator: LoginSelectionCoordinator = .init(),
        signupCoordinator: SignupCoordinator = .init(),
        claimABookingCoordinator: ClaimABookingCoordinator = .init()
    ) {
        self.sheetRouter = sheetRouter
        self.loginCoordinator = loginCoordinator
        self.signupCoordinator = signupCoordinator
        self.claimABookingCoordinator = claimABookingCoordinator
    }
    
    func dismissCurrentSheet() {
        sheetRouter.dismiss()
    }
    
    func dismissCurrentSheetWithoutAnimation() {
        sheetRouter.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            [weak self] in
            guard let self else { return }

            // Reset navigation stack after view dismiss animation is done.
            self.loginCoordinator.navigationRouter.goToRoot()
            self.signupCoordinator.navigationRouter.goToRoot()
            self.claimABookingCoordinator.navigationRouter.goToRoot()
        }

    }
}

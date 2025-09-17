//
//  SignUpSheetViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 17.1.25.
//

import Foundation
import SwiftUI

@Observable class SignUpSheetViewModel: BaseViewModelV2, SignUpSheetViewModelProtocol {

    var appCoordinator: CoordinatorProtocol = AppCoordinator.shared
    
    func dismiss() {
        appCoordinator.executeCommand(LandingScreensCoordinator.DismissCurrentSheetCommand())
    }
    
	func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let signupNavigationRoute = navigationRoute as? SignupNavigationRoute  else { return AnyView(Text("View not supported")) }

        switch signupNavigationRoute {
        case .landingScreen:
            return AnyView(
                SignUpLandingView(viewModel: SignUpLandingViewModel())
            )
        case .email:
            return AnyView(
                SignUpWithEmailView.create()
                    .navigationBarBackButtonHidden(true)
                
            )
        case .details(let email, let receiveEmails):
            return AnyView(
                SignUpDetailsView.create(viewModel: SignUpDetailsViewModel(model: SignUpInputModel(email: email, receiveEmails: receiveEmails)))
                    .navigationBarBackButtonHidden(true)
            )
        case .protectYourAccount(model: let model):
            return AnyView(
                ProtectYourAccountView.create(viewModel: ProtectYourAccountViewModel(signUpInputModel: model))
                    .navigationBarBackButtonHidden(true)
            )
        case .profilePhotoView(model: let model):
            return AnyView(
                ProfilePhotoView(viewModel: ProfilePhotoViewModel(signUpInputModel: model))
                    .navigationBarBackButtonHidden(true)
            )
        case .signUpProfileImageView(model: let model):
            return AnyView(
                SignUpProfileImageView.create(viewModel: SignUpProfileImageViewModel(signUpInputModel: model))
                    .navigationBarBackButtonHidden(true)
            )
        case .socialProfileView(model: let model):
            return AnyView(
                SocialProfileView.create(viewModel: SocialProfileViewModel(signUpInputModel: model)) 
                    .navigationBarBackButtonHidden(true)
            )
        }        
    }
}

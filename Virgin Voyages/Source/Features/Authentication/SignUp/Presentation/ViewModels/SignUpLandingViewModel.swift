//
//  SignUpLandingViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.9.24.
//

import Foundation
import UIKit

protocol SignUpLandingViewModelProtocol {
    var signUpInputModel: SignUpInputModel { get set }
    var isShipboard: Bool { get set }
    func dismissSheet()
    func navigateToSignUpWithEmail()
    func navigateToSocialProfileView()
	func onAppear()
    func loginWithAppleId() async -> Bool
    func loginWithFacebook() async -> Bool
    func loginWithGoogle(presentingViewController: UIViewController) async -> Bool
}

@Observable class SignUpLandingViewModel: BaseViewModelV2, SignUpLandingViewModelProtocol {
    
    private var appCoordinator: CoordinatorProtocol

    // MARK: - Use case
    private let loginUseCase: LoginUseCaseProtocol
	let appleLoginUseCase: AppleLoginUseCase
	let googleLoginUseCase: GoogleLoginUseCase
    let facebookLoginUseCase: FacebookLoginUseCase
	let getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCase
    var signUpInputModel: SignUpInputModel
    var isShipboard: Bool = true
    var loginButtonTitle: String = ""

    // MARK: - Init
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         loginUseCase: LoginUseCaseProtocol = LoginUseCase(),
		 appleLoginUseCase: AppleLoginUseCase = AppleLoginUseCase(),
		 signUpInputModel: SignUpInputModel = SignUpInputModel(),
		 googleLoginUseCase: GoogleLoginUseCase = GoogleLoginUseCase(),
		 facebookLoginUseCase: FacebookLoginUseCase = FacebookLoginUseCase(),
		 getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCase = GetSailorShoreOrShipUseCase()
	) {
        self.appCoordinator = appCoordinator
		self.loginUseCase = loginUseCase
        self.appleLoginUseCase = appleLoginUseCase
        self.signUpInputModel = signUpInputModel
        self.googleLoginUseCase = googleLoginUseCase
        self.facebookLoginUseCase = facebookLoginUseCase
		self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
    }

	func onAppear() {
		let result = getSailorShoreOrShipUseCase.execute()
		isShipboard = result.isOnShip
	}

    // MARK: - Login with apple id
    func loginWithAppleId() async -> Bool {
        guard let result = await appleLoginUseCase.execute() else { return true }
        if let token = result.id {
            let loginResult = try? await loginUseCase.execute(.social(socialMediaId: token, type: .apple))
            if case .success = loginResult {
				return true
			} else {
				self.signUpInputModel = result.toSignUpInputModel()
				self.signUpInputModel.socialMediaType = .apple
				self.signUpInputModel.socialMediaId = result.id
				return false
			}
        } else {
            return true
        }
    }
    
    // MARK: - Login with Google
    func loginWithGoogle(presentingViewController: UIViewController) async -> Bool {
        do {
            let result = try await googleLoginUseCase.execute(presentingViewController: presentingViewController)
            if let token = result.id {
                let loginResult = try? await loginUseCase.execute(.social(socialMediaId: token, type: .google))
                if case .success = loginResult {
					return true
				} else {
					self.signUpInputModel = result.toSignUpInputModel()
					self.signUpInputModel.socialMediaType = .google
					self.signUpInputModel.socialMediaId = result.id
					return false
				}
            } else {
                return true
            }
        } catch {
            return true
        }
    }
    
    // MARK: - Login with Facebook
    func loginWithFacebook() async -> Bool {
        do {
            guard let result = try await facebookLoginUseCase.execute() else { return false }
            if let token = result.id {
                let loginResult = try? await loginUseCase.execute(.social(socialMediaId: token, type: .facebook))
                if case .success = loginResult {
					return true
				} else {
					self.signUpInputModel = result.toSignUpInputModel()
					self.signUpInputModel.socialMediaType = .facebook
					self.signUpInputModel.socialMediaId = result.id
					return false
				}
            } else {
                return true
            }
        }catch {
            return true
        }
    }
    
    
    // MARK: Navigation
    func navigateToSignUpWithEmail() {
        appCoordinator.executeCommand(SignupCoordinator.OpenSignUpWithEmailCommand())
    }
    
    func navigateToSocialProfileView() {
        appCoordinator.executeCommand(SignupCoordinator.OpenSocialProfileViewCommand(signUpInputModel: signUpInputModel))
    }
    
    func dismissSheet() {
        appCoordinator.executeCommand(SignupCoordinator.DismissSignUpSheetCommand())
    }
}

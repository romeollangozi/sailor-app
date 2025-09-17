//
//  LoginSelectionViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.9.24.
//

import Foundation
import SwiftUI

protocol LoginSelectionViewModelProtocol {
    func loginWithAppleID()
    func loginWithFacebook()
    func loginWithGoogle(presentingViewController: UIViewController)
    func closeSheet()
    func loginWithEmailButtonTapped()
    func loginWithBookingReferenceButtonTapped()
    func onAppear()
	func signInWithFacebook(user: SocialUser) async throws
	func signInWithGoogle(user: SocialUser) async throws
    var appCoordinator: CoordinatorProtocol { get set }
    var appleLoginUseCase: AppleLoginUseCaseProtocol { get set }
    var googleLoginUseCase: GoogleLoginUseCaseProtocol { get set }
    var facebookLoginUseCase: FacebookLoginUseCaseProtocol { get set }
    var signUpInputModel: SignUpInputModel { get set }
    var loginButtonTitle: String { get }
    var isUserOnShip: Bool { get }
}

@Observable class LoginSelectionViewModel: BaseViewModelV2, LoginSelectionViewModelProtocol {
    
    private static let facebookCancelledDomain = "Canceled"
    private static let googleSignInDomain = "com.google.GIDSignIn"
    
    private static let genericLoginErrorMessage = "Something went wrong. Please try again later."
    private static let loginWithShipboardTitle = "Login with Shipboard"
    private static let loginWithBookingReferenceTitle = "Login with Booking reference"

    // MARK: Navigation Coordinator
    var appCoordinator: CoordinatorProtocol
    
    // MARK: - Use case
    var appleLoginUseCase: AppleLoginUseCaseProtocol
    var googleLoginUseCase: GoogleLoginUseCaseProtocol
    var facebookLoginUseCase: FacebookLoginUseCaseProtocol
    var signUpInputModel: SignUpInputModel
    var isUserOnShip: Bool {
        getSailorShoreOrShipUseCase.execute().isOnShip
    }
    private let loginUseCase: LoginUseCaseProtocol
    private let getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol
    private var getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol

    // MARK: - Init
    init(
		appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
        loginUseCase: LoginUseCaseProtocol = LoginUseCase(),
		appleLoginUseCase: AppleLoginUseCaseProtocol = AppleLoginUseCase(),
		googleLoginUseCase: GoogleLoginUseCaseProtocol =  GoogleLoginUseCase(),
		facebookLoginUseCase: FacebookLoginUseCaseProtocol = FacebookLoginUseCase(),
		signUpInputModel: SignUpInputModel = SignUpInputModel(),
        getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol = GetUserShoresideOrShipsideLocationUseCase(),
        getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase()
	) {
        self.appCoordinator = appCoordinator
        self.loginUseCase = loginUseCase
        self.appleLoginUseCase = appleLoginUseCase
        self.googleLoginUseCase = googleLoginUseCase
        self.facebookLoginUseCase = facebookLoginUseCase
        self.signUpInputModel = signUpInputModel
        self.getUserLocationShoresideOrShipsideLocationUseCase = getUserLocationShoresideOrShipsideLocationUseCase
        self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
    }
    
    // MARK: - Login button title
    var loginButtonTitle: String {
        let sailorLocation = getUserLocationShoresideOrShipsideLocationUseCase.execute()
        return sailorLocation == .ship
            ? LoginSelectionViewModel.loginWithShipboardTitle
            : LoginSelectionViewModel.loginWithBookingReferenceTitle
    }
    
    func onAppear() {
    }
    
    // MARK: - Login with apple id
    func loginWithAppleID() {
        
        Task { [weak self] in
            
            guard let self,
                  let signedInUser = await self.appleLoginUseCase.execute() else { return }
            
            do {
                
                try await UseCaseExecutor.execute {
                    try await self.signInWithApple(user: signedInUser)
                }
                
            } catch (let error) as VVDomainError {
                
                let errorMessage = extractValidationErrorMessage(error)
                showErrorWithSocialLoginFullCoverSheet(errorMessage: errorMessage)
                
            } catch {
                
				showErrorWithSocialLoginFullCoverSheet(errorMessage: LoginSelectionViewModel.genericLoginErrorMessage)

            }
        }
        
    }
    
    private func signInWithApple(user: SocialUser) async throws {
        
        if let token = user.id {
            
            do {
                try await loginUseCase.execute(.social(socialMediaId: token, type: .apple))
            } catch let error as Endpoint.FieldsValidationError {
                
                self.signUpInputModel = user.toSignUpInputModel()
                
                let validationError = ValidationError(fieldErrors: [], errors: [error.errors.joined(separator: "")])
                throw VVDomainError.validationError(error: validationError)
                
            }
        }
        
    }

    // MARK: - Login with Facebook
    
    func loginWithFacebook() {
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                try await UseCaseExecutor.execute {
                    
                    guard let signedInUser = try await self.facebookLoginUseCase.execute() else { return }
                    
                    try await self.signInWithFacebook(user: signedInUser)
                    
                }
                
            } catch (let error) as VVDomainError {
                
                let errorMessage = extractValidationErrorMessage(error)
                showErrorWithSocialLoginFullCoverSheet(errorMessage: errorMessage)
                
            } catch(let error) {
				if isUserCancelledError(error) { return }
				showErrorWithSocialLoginFullCoverSheet(errorMessage: LoginSelectionViewModel.genericLoginErrorMessage)

            }
            
        }
    }

    func signInWithFacebook(user: SocialUser) async throws {
        
        if let socialMediaId = user.id {

            do {
                try await loginUseCase.execute(.social(socialMediaId: socialMediaId, type: .facebook))
			} catch _ as Endpoint.FieldsValidationError {
                self.presentSignUpWithSocialUser(for: user, socialMediaType: .facebook, socialMediaId: socialMediaId)
            }
        }
        
    }
    
    // MARK: - Login with Google
    
    func loginWithGoogle(presentingViewController: UIViewController) {
        
        Task { [weak self] in

            guard let self else { return }
            
            do {
                
                try await UseCaseExecutor.execute {
                    
                    let signedInUser = try await self.googleLoginUseCase.execute(presentingViewController: presentingViewController)
                    
                    try await self.signInWithGoogle(user: signedInUser)
                    
                }
                
            } catch {
                handleSocialLoginError(error)
            }
        }
        
    }
    
    func signInWithGoogle(user: SocialUser) async throws {
        
        if let socialMediaId = user.id {
            
            do {
                try await loginUseCase.execute(.social(socialMediaId: socialMediaId, type: .google))                
			} catch _ as Endpoint.FieldsValidationError {
				self.presentSignUpWithSocialUser(for: user, socialMediaType: .google, socialMediaId: socialMediaId)
            }
        }
        
    }

	func isUserCancelledError(_ error: Error) -> Bool {
		guard let nsError = error as NSError? else { return false }

		// Handle Facebook login cancellation
		if nsError.domain == Self.facebookCancelledDomain && nsError.code == -1 {
			return true
		}

		// Handle Google Sign-In cancellation
		if nsError.domain == Self.googleSignInDomain && nsError.code == -5 {
			return true
		}

		return false
	}

    // MARK: Navigation
    func closeSheet() {
        appCoordinator.executeCommand(LandingScreensCoordinator.DismissCurrentSheetCommand())
    }
    
    func loginWithEmailButtonTapped() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.OpenLoginWithEmailCommand())
    }
    
    func loginWithBookingReferenceButtonTapped() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.OpenLoginWithBookingReferenceCommand())
    }
    
    private func showErrorWithSocialLoginFullCoverSheet(errorMessage: String) {
        appCoordinator.executeCommand(LoginSelectionCoordinator.ShowErrorWithSocialLoginFullCoverSheet(errorMessage: errorMessage))
    }
    
    private func extractValidationErrorMessage(_ error: VVDomainError) -> String {
        if case VVDomainError.validationError(let validationError) = error {
            return validationError.errors.joined(separator: "")
        }
		return LoginSelectionViewModel.genericLoginErrorMessage
    }
    
    private func presentSignUpWithSocialUser(for user: SocialUser, socialMediaType: SocialMediaType, socialMediaId: String) {
        self.signUpInputModel = user.toSignUpInputModel()
        self.signUpInputModel.socialMediaType = socialMediaType
        self.signUpInputModel.socialMediaId = socialMediaId
        appCoordinator.executeCommand(LandingScreensCoordinator.DismissCurrentSheetAndOpenSignUpCommand(model: signUpInputModel))
    }
    
    private func handleSocialLoginError(_ error: Error) {
        if isUserCancelledError(error) { return }
        if let domainError = error as? VVDomainError {
            let errorMessage = extractValidationErrorMessage(domainError)
            showErrorWithSocialLoginFullCoverSheet(errorMessage: errorMessage)
        } else {
            showErrorWithSocialLoginFullCoverSheet(errorMessage: LoginSelectionViewModel.genericLoginErrorMessage)
        }
    }
}


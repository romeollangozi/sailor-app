//
//  RequestNewPasswordViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.9.24.
//

import Foundation

protocol RequestNewPasswordViewModelProtocol {
    var appCoordinator: CoordinatorProtocol { get set }
    var email: String { get set }
    var nextButtonDisabled: Bool { get }
    var error: String? { get }
    var reCaptchaToken: String? { get set }
    var reCaptchaIsChecked: Bool { get set }
    var reCaptchaError: String? { get }
    var hasValidReCaptcha: Bool? { get }
    var isValid: Bool { get }
    var isLoadingResetMyPassword: Bool { get }
    
    var requestNewPasswordUseCase: RequestNewPasswordUseCase { get }
    var clientTokenUseCase: ClientTokenUseCase { get }
    func requestNewPassword() async -> RequestNewPasswordResponse
    func validate()
    func navigateToPreviousView()
    func navigateBackToRootView()
    func navigateToNewPasswordRequestedScreen()
    func navigateToEmailNotRecognisedScreen()
}

@Observable class RequestNewPasswordViewModel: RequestNewPasswordViewModelProtocol {

    // MARK: - Propertis
    var appCoordinator: CoordinatorProtocol
    var email: String
    var error: String?
    var reCaptchaToken: String?
    var reCaptchaIsChecked: Bool = false
    var reCaptchaError: String?
    var isLoadingResetMyPassword = false
    var requestNewPasswordUseCase: RequestNewPasswordUseCase
    var clientTokenUseCase: ClientTokenUseCase
    var nextButtonDisabled: Bool {
        return !email.isValidEmail()
    }
    var hasValidReCaptcha: Bool?
    var isValid: Bool {
        return  email.isValidEmail() && isValidRecaptcha
    }
    
    // MARK: - Init
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         email: String = "",
         hasValidReCaptcha: Bool? = nil,
         requestNewPasswordUseCase: RequestNewPasswordUseCase = RequestNewPasswordUseCase(),
         clientTokenUseCase: ClientTokenUseCase = ClientTokenUseCase()) {
        
        self.appCoordinator = appCoordinator
        self.email = email
        self.hasValidReCaptcha = hasValidReCaptcha
        self.requestNewPasswordUseCase = requestNewPasswordUseCase
        self.clientTokenUseCase = clientTokenUseCase
    }
    
    // MARK: - Validation
    func validate() {
        (email.isValidEmail() == true) ? (error = nil) : (error = (email.isEmpty ? "Please enter an email address" : "Oops, this doesn’t appear to be a valid email address."))
        let error = "Please verify that you are not a robot"
        guard let _ = reCaptchaToken else {
            reCaptchaError = error
            return
        }
        reCaptchaError = (reCaptchaIsChecked == true) ? nil : error
    }
    
    @MainActor
    func requestNewPassword() async -> RequestNewPasswordResponse {
        isLoadingResetMyPassword = true
        if let token = await clientTokenUseCase.execute() {
            let reset = await requestNewPasswordUseCase.execute(email: email, clientToken: token, reCaptcha: reCaptchaToken.value)
            isLoadingResetMyPassword = false
            return reset
        } else {
            isLoadingResetMyPassword = false
            return (isEmailExist: false, isEmailSent: false)
        }
    }

    private var isValidRecaptcha: Bool {
        if let reCaptchaToken, !reCaptchaToken.isEmpty {
            return true
        }
        return false
    }

    
    // MARK: Navigation 
    func navigateToPreviousView() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.GoBackCommand())
    }
    
    func navigateBackToRootView() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.GoBackToRootViewCommand())
    }
    
    func navigateToNewPasswordRequestedScreen() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.OpenNewPasswordRequestedCommand())
    }
    
    func navigateToEmailNotRecognisedScreen() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.OpenEmailNotRecognisedCommand())
    }
    
}

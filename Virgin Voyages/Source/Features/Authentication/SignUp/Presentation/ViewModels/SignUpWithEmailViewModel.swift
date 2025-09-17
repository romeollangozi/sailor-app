//
//  SignUpWithEmailViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import SwiftUI

@MainActor
protocol SignUpWithEmailViewModelProtocol {
    
    var email: String { get set }
    var isChecked: Bool { get set }
    var nextButtonDisabled: Bool { get }
    var errorMessage: String? { get set }
    var isLoading: Bool { get set }

    func onEmailFieldFocusChanged(oldValue: Bool, newValue: Bool)
    func resetErrorMessage()

    func navigateBack()
    func navigateBackToRootView()
    func nextButtonTapped(email: String, receiveEmails: Bool)
}

@MainActor
@Observable class SignUpWithEmailViewModel: BaseViewModelV2, SignUpWithEmailViewModelProtocol {
    
    private var clientTokenUseCase: ClientTokenUseCase
    private var validateEmailUseCase: ValidateEmailUseCaseProtocol
    
    // MARK: - Propertis
    var email: String = ""
    var isChecked: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
    
    var nextButtonDisabled: Bool {
        isLoading || !isEmailFieldValid
    }
    
    private var isEmailFieldValid: Bool {
        email.isValidEmail()
    }
    
    private let localizationManager: LocalizationManagerProtocol
    
    // MARK: - Init
    init(clientTokenUseCase: ClientTokenUseCase = ClientTokenUseCase(),
         validateEmailUseCase: ValidateEmailUseCaseProtocol = ValidateEmailUseCase(),
         email: String = "",
         isChecked: Bool = false,
         localizationManager: LocalizationManagerProtocol = LocalizationManager.shared
    ) {
        self.clientTokenUseCase = clientTokenUseCase
        self.validateEmailUseCase = validateEmailUseCase
        self.email = email
        self.isChecked = isChecked
        self.localizationManager = localizationManager
    }
    
    func nextButtonTapped(email: String, receiveEmails: Bool) {
        guard validateEmailField() else { return }
        
        Task { [weak self] in
            guard let self = self else { return }
            self.isLoading = true
            guard let token = await self.clientTokenUseCase.execute() else {
                self.isLoading = false
                self.errorMessage = localizationManager.getString(for: .errorContentWentWrongHeadline)
                return
            }
            
            let validateEmailResult = try await UseCaseExecutor.execute({
                try await self.validateEmailUseCase.execute(email: email, clientToken: token)
            })
            
            self.isLoading = false
            if validateEmailResult.isEmailExist {
                self.errorMessage = "This email already exists"
            } else {
                self.errorMessage = nil
                self.openSignUpDetailsView(email: email, receiveEmails: receiveEmails)
            }
        }
    }
    
    func resetErrorMessage() {
        withAnimation {
            self.errorMessage = nil
        }
    }
    
    func onEmailFieldFocusChanged(oldValue: Bool, newValue: Bool) {
        if oldValue == true && newValue == false {
            // Only validate when focus is lost
            validateEmailField()
        }
    }
    
    @discardableResult func validateEmailField() -> Bool {
        withAnimation {
            errorMessage = isEmailFieldValid ? nil : localizationManager.getString(for: .errorContentEmailAddressInvalidError)
        }
        return isEmailFieldValid
    }
    
    // MARK: Navigation
    func navigateBack() {
        navigationCoordinator.executeCommand(SignupCoordinator.GoBackCommand())
    }
    
    func navigateBackToRootView() {
		navigationCoordinator.executeCommand(SignupCoordinator.GoBackToRootViewCommand())
    }
    
    func openSignUpDetailsView(email: String, receiveEmails: Bool) {
		navigationCoordinator.executeCommand(SignupCoordinator.OpenSignupDetailsCommand(email: email, receiveEmails: receiveEmails))
    }
}

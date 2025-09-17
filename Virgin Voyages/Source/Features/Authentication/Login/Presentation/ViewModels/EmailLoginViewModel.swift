//
//  EmailLoginViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import Foundation
import LocalAuthentication


@Observable class EmailLoginViewModel: BaseViewModelV2, EmailLoginViewModelProtocol {

    // MARK: - Constants
    struct ErrorMessages {
        static let genericErrorMessage = "Something went wrong. Please try again later."
    }

    // MARK: - Private Properties
    private let loginUseCase: LoginUseCaseProtocol
    private let checkIfAccountIsDeactivatedUseCase: CheckIfAccountIsDeactivatedUseCase
    private let retrieveCredentialsWithBiometricsUseCase: RetrieveCredentialsWithBiometricsUseCase

    // MARK: - Public Properties
    var shouldShowDeactivatedAccountSheet: Bool = false
    var email: String = ""
    var password: String = ""
    var errorMessage: String?

    var loginButtonDisabled: Bool {
        return email == "" || password == "" || loggingIn
    }

    var userInterfaceDisabled: Bool {
        return loggingIn
    }

    var isIncorrectEmailOrPassword: Bool = false
    var loggingIn: Bool = false

    // MARK: - Initialization
    init(
        loginUseCase: LoginUseCaseProtocol = LoginUseCase(),
        checkIfAccountIsDeactivatedUseCase: CheckIfAccountIsDeactivatedUseCase = CheckIfAccountIsDeactivatedUseCase(),
        retrieveCredentialsWithBiometricsUseCase: RetrieveCredentialsWithBiometricsUseCase = RetrieveCredentialsWithBiometricsUseCase()
    ) {
        self.loginUseCase = loginUseCase
        self.checkIfAccountIsDeactivatedUseCase = checkIfAccountIsDeactivatedUseCase
        self.retrieveCredentialsWithBiometricsUseCase = retrieveCredentialsWithBiometricsUseCase
    }

    // MARK: - Lifecycle Methods
    func onAppear() {
        Task {
            let result = await retrieveCredentialsWithBiometricsUseCase.execute()
            if case .success(let credentials) = result {
                email = credentials.email
                password = credentials.password
            }
        }
    }

    // MARK: - Actions
    func loginButtonTapped() {
        loggingIn = true

        Task { [weak self] in
            guard let self else { return }

            do {
                try await UseCaseExecutor.execute {
                    let cleanEmail = self.cleanInput(self.email)
                    let cleanPassword = self.cleanInput(self.password)
                    try await self.loginUseCase.execute(.email(email: cleanEmail, password: cleanPassword))
                }

                self.handleSuccessfulLogin()
            } catch (let error) as VVDomainError {
                self.handleDomainError(error)
            } catch {
                self.handleGenericError()
            }
        }
    }

    func cancelButtonTapped() {
        goToPreviousView()
    }

    func forgotPasswordButtonTapped() {
        navigationCoordinator.executeCommand(LoginSelectionCoordinator.OpenForgotPasswordCommand())
    }

    // MARK: - Error Handling
    private func handleDomainError(_ error: VVDomainError) {
        loggingIn = false
        isIncorrectEmailOrPassword = true

        if case VVDomainError.validationError(let validationError) = error {
            errorMessage = validationError.errors.joined(separator: "")
        }
    }

    private func handleGenericError() {
        loggingIn = false
        isIncorrectEmailOrPassword = true
        errorMessage = ErrorMessages.genericErrorMessage
    }

    // MARK: - Navigation
    func goToPreviousView() {
        navigationCoordinator.executeCommand(LoginSelectionCoordinator.GoBackCommand())
    }

    private func dismissAndShowDeactivatedAccountSheet() {
        navigationCoordinator.executeCommand(LandingScreensCoordinator.OpenClaimABookingDeactivatedAccountScreenCommand())
    }

    private func resetNavigationForNextLogin() {
        navigationCoordinator.executeCommand(LoginSelectionCoordinator.DismissAndResetNavigationStateCommand())
    }

    // MARK: - Private Helpers
    private func cleanInput(_ input: String) -> String {
        return input.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func handleSuccessfulLogin() {
        loggingIn = false
        isIncorrectEmailOrPassword = false
        resetNavigationForNextLogin()

        if checkIfAccountIsDeactivatedUseCase.execute() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismissAndShowDeactivatedAccountSheet()
            }
        }
    }
}


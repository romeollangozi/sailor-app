//
//  SignUpDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.8.24.
//

import SwiftUI

@MainActor
protocol SignUpDetailsViewModelProtocol {
    var signUpInputModel: SignUpInputModel  { get set }
    var dateOfBirthError: String?  { get }
    var nextButtonDisabled: Bool { get }
    var showClarification: Bool { get }
    var clarification: String { get }

    // inline errors for required fields
    var firstNameError: String? { get }
    var lastNameError: String?  { get }
    var nameError: String? { get }

    func onFirstNameFocusChanged(oldValue: Bool, newValue: Bool)
    func onLastNameFocusChanged(oldValue: Bool, newValue: Bool)
    func resetFirstNameError()
    func resetLastNameError()

    func isValidDate() -> Bool

    func navigateBack()
    func navigateBackToRoot()
    func openProtectYourAccount(signUpMethodModel: SignUpInputModel)
}

@Observable
final class SignUpDetailsViewModel: SignUpDetailsViewModelProtocol {
    private var appCoordinator: CoordinatorProtocol
    private let localizationManager: LocalizationManagerProtocol
    
    // Input model
    var signUpInputModel: SignUpInputModel

    // Inline errors for names
    var firstNameError: String?
    var lastNameError: String?

    var nameError: String? {
        firstNameError ?? lastNameError
    }

    var nextButtonDisabled: Bool {
        !(isValidInput() && isValidDate())
    }

    var dateOfBirthError: String? {
        if signUpInputModel.dateOfBirth.isFullySpecifiedDate() {
            return (signUpInputModel.dateOfBirth.isOlderThan16Years && signUpInputModel.dateOfBirth.isValidDate()) ? nil : ""
        }
        return nil
    }

    var clarification: String {
        localizationManager.getString(for: .loginRegisterAgeFailMessage)
    }

    var showClarification: Bool {
        guard let error = dateOfBirthError else { return false }
        return error.isEmpty
    }

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         model: SignUpInputModel,
         localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
        self.appCoordinator = appCoordinator
        self.signUpInputModel = SignUpInputModel(email: model.email, receiveEmails: model.receiveEmails)
        self.localizationManager = localizationManager
    }

    // MARK: - Validation
    func isValidInput() -> Bool {
        let validFirst = signUpInputModel.firstName.isValidName()
        let validLast  = signUpInputModel.lastName.isValidName()
        return validFirst && validLast && isValidDate()
    }

    func isValidDate() -> Bool {
        (dateOfBirthError == nil) && signUpInputModel.dateOfBirth.isOlderThan16Years    }

    func onFirstNameFocusChanged(oldValue: Bool, newValue: Bool) {
        if oldValue, !newValue {
            withAnimation {
                firstNameError = signUpInputModel.firstName.isValidName() ? nil : "Please enter a valid first name."
            }
        }
    }

    func onLastNameFocusChanged(oldValue: Bool, newValue: Bool) {
        if oldValue, !newValue {
            withAnimation {
                lastNameError = signUpInputModel.lastName.isValidName() ? nil : "Please enter a valid last name."
            }
        }
    }

    func resetFirstNameError() { withAnimation { firstNameError = nil } }
    func resetLastNameError()  { withAnimation { lastNameError  = nil } }

    // MARK: - Navigation
    func navigateBack() {
        appCoordinator.executeCommand(SignupCoordinator.GoBackCommand())
    }
    func openProtectYourAccount(signUpMethodModel: SignUpInputModel) {
        appCoordinator.executeCommand(SignupCoordinator.OpenProtectYourAccountCommand(signUpMethodModel: signUpMethodModel))
    }
    func navigateBackToRoot() {
        appCoordinator.executeCommand(SignupCoordinator.GoBackToRootViewCommand())
    }
}

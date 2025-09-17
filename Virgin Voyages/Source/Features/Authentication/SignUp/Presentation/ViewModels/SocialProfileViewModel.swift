//
//  SocialProfileViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.9.24.
//

import SwiftUI

protocol SocialProfileViewModelProtocol {
    var signUpInputModel: SignUpInputModel { set get }
    var cameraTask: ScreenTask { set get }
    var profileImage: Image { get }
    var dateOfBirthError: String?  { get }
    var nextButtonDisabled: Bool { get }
    var showClarification: Bool { get }
    var clarification: String { get }
    var emailError: String? { get set }
    var isLoading: Bool { get set }
    func isValidDate() -> Bool
    func signUp()
    func navigateBack()
    func navigateBackToRoot()
}

@Observable class SocialProfileViewModel: BaseViewModel, SocialProfileViewModelProtocol {

    private var appCoordinator: CoordinatorProtocol
    // MARK: - Properties
    var signUpInputModel: SignUpInputModel
    var cameraTask: ScreenTask = ScreenTask()
    var emailError: String?
    var isLoading: Bool = false
    
    // MARK: - Use cases
    private var signUpUseCase: SignUpUseCaseProtocol
    private var signUpWithSocialUseCase: SignUpWithSocialUseCaseProtocol
    
    // MARK: - Computed properties
    var nextButtonDisabled: Bool {
        return !(isValidInput() && isValidDate())
    }
    
    var dateOfBirthError: String? {
        if signUpInputModel.dateOfBirth.isFullySpecifiedDate() {
            return (signUpInputModel.dateOfBirth.isOlderThan16Years && signUpInputModel.dateOfBirth.isValidDate()) ? nil : ""
        }
        return nil
    }
    
    var clarification: String {
        return "Accounts can only be established for sailors over the age of 13, so if you don’t remember a world without social media, we’re going to have to ask you to leave"
    }
    
    var showClarification: Bool {
        guard let _dateOfBirthError = dateOfBirthError else { return false }
        return _dateOfBirthError.isEmpty
    }
    
    var profileImage: Image {
        guard let imageData = signUpInputModel.imageData else { return Image("ProfilePlaceholder") }
        return Image(data: imageData)
    }
    
    // MARK: - Validate
    func isValidDate() -> Bool {
        return (dateOfBirthError == nil) && signUpInputModel.dateOfBirth.isOlderThan16Years    }
    

    // MARK: - Init
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         signUpInputModel: SignUpInputModel,
         cameraTask: ScreenTask = ScreenTask() ,
         signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(),
         signUpWithSocialUseCase: SignUpWithSocialUseCaseProtocol = SignUpWithSocialUseCase()) {
        
        self.appCoordinator = appCoordinator
        self.signUpInputModel = signUpInputModel
        self.signUpUseCase = signUpUseCase
        self.signUpWithSocialUseCase = signUpWithSocialUseCase
    }
    
    // MARK: - SignUp
    func signUp() {
        if isValidInput() {
            switch signUpInputModel.isSocialMediaUser {
            case true:
                signUpWithSocial()
            case false:
                signUpWithEmail()
            }
        }
    }
    
    // MARK: - SignUp with email
    private func signUpWithEmail() {
        Task {
            // Start loading
            isLoading(value: true)
            
            //TODO: Needs error handling implementation!!
            await executeUseCase({ [weak self] in
                guard let self else { return }
                try await self.signUpUseCase.execute(signUpUser: self.signUpInputModel)
            })
        
            // Finish loading, dismiss the sheet and
            isLoading(value: false)
        }
    }
    
    private func isLoading(value: Bool) {
        DispatchQueue.main.async {
            self.isLoading = value
        }
    }
    
    // MARK: - SignUp with social network
    private func signUpWithSocial() {
        Task {
            isLoading(value: true)
            
            await executeUseCase({ [weak self] in
                guard let self else { return }
                try await self.signUpWithSocialUseCase.execute(signUpUser: self.signUpInputModel)
            })
           
            isLoading(value: false)
        }
    }
    
    // MARK: - Validate
    private func isValidInput() -> Bool {
        let validFirstName = signUpInputModel.firstName.isValidName()
        let validLastName = signUpInputModel.lastName.isValidName()
        self.emailError = signUpInputModel.email.isValidEmail() ? nil : ""
        return (validFirstName && validLastName && isValidDate() && signUpInputModel.email.isValidEmail())
    }
    
    // MARK: Navigation
    func navigateBack() {
        appCoordinator.executeCommand(SignupCoordinator.GoBackCommand())
    }
    
    func navigateBackToRoot() {
        appCoordinator.executeCommand(SignupCoordinator.GoBackToRootViewCommand())
    }
}

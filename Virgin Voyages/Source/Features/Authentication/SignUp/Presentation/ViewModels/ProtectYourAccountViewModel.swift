//  ProtectYourAccountViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.9.24.
//

import Foundation

protocol ProtectYourAccountViewModelProtocol {
	var signUpInputModel: SignUpInputModel  { get set }
	var password: String { get set }
	var validations: [Bool] { get set }
	var criteria: [PasswordCriteria] { get }
	var nextButtonDisabled: Bool { get }
	var wrongPasswordText: String? { get }

	func navigateBack()
	func navigateBackToRoot()
	func navigateToProfileImageView()
}

@Observable class ProtectYourAccountViewModel: ProtectYourAccountViewModelProtocol {

	private var appCoordinator: CoordinatorProtocol

	// MARK: - Private properties
	private var validationItems: [Bool]
	// MARK: - Properties
	var signUpInputModel: SignUpInputModel

	var wrongPasswordText: String? {
		get {
			if password.isEmpty { return nil }
			if isValidPassword() { return nil }
			else { return ""}
		}
	}

	init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared, signUpInputModel: SignUpInputModel, validationItems: [Bool] = Array(repeating: false, count: 4)) {
		self.appCoordinator = appCoordinator
		self.signUpInputModel = signUpInputModel
		self.validationItems = validationItems
	}

	var password: String {
		get { return signUpInputModel.password }
		set {
			signUpInputModel.password = newValue
			validatePassword(newValue)
		}
	}

	var validations: [Bool] {
		get {
			return validationItems
		}
		set {
			validationItems = newValue
		}
	}

	var criteria: [PasswordCriteria] {
		get {
			return [PasswordCriteria(regex: "^.{8,}$", message: "At least 8 characters"),
					PasswordCriteria(regex: ".*[A-Z].*", message: "At least 1 uppercase letter"),
					PasswordCriteria(regex: ".*\\d.*", message: "At least 1 number"),
					PasswordCriteria(regex: ".*[!@#$%^&*(),.?\":{}|<>].*", message: "At least 1 symbol")]
		}
	}

	var nextButtonDisabled: Bool {
		return !isValidPassword()
	}

	private func validatePassword(_ password: String) {
		for (index, criterion) in criteria.enumerated() {
			validations[index] = criterion.isValid(password)
		}
	}

	private func isValidPassword() -> Bool {
		for criterion in criteria {
			if !criterion.isValid(password) {
				return false
			}
		}
		return true
	}

	// MARK: Navigation
	func navigateBack() {
		appCoordinator.executeCommand(SignupCoordinator.GoBackCommand())
	}

	func navigateToProfileImageView() {
		appCoordinator.executeCommand(SignupCoordinator.OpenStrikePoseViewCommand(signUpInputModel: signUpInputModel))
	}

	func navigateBackToRoot() {
		appCoordinator.executeCommand(SignupCoordinator.GoBackToRootViewCommand())
	}


}

struct PasswordCriteria {
	let regex: String
	let message: String

	func isValid(_ password: String) -> Bool {
		return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
	}
}

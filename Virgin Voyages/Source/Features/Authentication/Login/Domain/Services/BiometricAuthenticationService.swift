//
//  BiometricAuthenticationService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/23/24.
//

import Foundation
import LocalAuthentication

protocol BiometricAuthenticationService {
	func isBiometricAuthenticationAvailable() -> Bool
	func authenticateWithBiometrics() async -> Bool
}

class AppleBiometricAuthenticationService: BiometricAuthenticationService {

	private var reason: String

	init(reason: String = "Use Face ID to log in to your account") {
		self.reason = reason
	}

	let context = LAContext()

	func isBiometricAuthenticationAvailable() -> Bool {
		return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
	}

	func authenticateWithBiometrics() async -> Bool {
		return await withCheckedContinuation { continuation in
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
				continuation.resume(returning: success)
			}
		}
	}
}

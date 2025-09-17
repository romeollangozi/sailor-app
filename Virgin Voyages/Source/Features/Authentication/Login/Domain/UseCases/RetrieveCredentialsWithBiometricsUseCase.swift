//
//  RetrieveCredentialsWithBiometricsUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import Foundation

enum RetrieveCredentialsWithBiometricsUseCaseError: Error {
	case biometricAuthenticationFailed
	case credentialsNotFound
	case biometricUnavailable
}

extension RetrieveCredentialsWithBiometricsUseCase {
	static func create(reason: String) -> RetrieveCredentialsWithBiometricsUseCase {
		let credentialsService = CredentialsService()
		let biometricsAuthenticationService = AppleBiometricAuthenticationService(reason: reason)
		return RetrieveCredentialsWithBiometricsUseCase(credentialsService: credentialsService,
														biometricsAuthenticationService: biometricsAuthenticationService)
	}
}

class RetrieveCredentialsWithBiometricsUseCase {

	private var credentialsService: CredentialsServiceProtocol
	private var biometricsAuthenticationService: BiometricAuthenticationService

	init(credentialsService: CredentialsServiceProtocol = CredentialsService(), 
		 biometricsAuthenticationService: BiometricAuthenticationService = AppleBiometricAuthenticationService()) {
		self.credentialsService = credentialsService
		self.biometricsAuthenticationService = biometricsAuthenticationService
	}

	func execute() async -> Result<(email: String, password: String), RetrieveCredentialsWithBiometricsUseCaseError> {
		if biometricsAuthenticationService.isBiometricAuthenticationAvailable() {
			guard let credentials = credentialsService.retrieveCredentials() else {
				return .failure(.credentialsNotFound)
			}

			let success = await biometricsAuthenticationService.authenticateWithBiometrics()

			return success ? .success(credentials) : .failure(.biometricAuthenticationFailed)
		} else {
			return .failure(.biometricUnavailable)
		}
	}
}

//
//  RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/29/24.
//

import Foundation

enum RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCaseError: Error {
	case biometricAuthenticationFailed
	case bookingDetailsNotFound
	case biometricUnavailable
}

extension RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase {
	static func create(reason: String) -> RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase {
		let shoresideBookingReferenceDetailsRepository = ShoresideBookingReferenceDetailsRepository()
		let biometricsAuthenticationService = AppleBiometricAuthenticationService(reason: reason)
		return RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase(shoresideBookingReferenceDetailsRepository: shoresideBookingReferenceDetailsRepository,
																			 biometricsAuthenticationService: biometricsAuthenticationService)
	}
}

class RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase {
	private var shoresideBookingReferenceDetailsRepository: ShoresideBookingReferenceDetailsRepositoryProtocol
	private var biometricsAuthenticationService: BiometricAuthenticationService

	init(shoresideBookingReferenceDetailsRepository: ShoresideBookingReferenceDetailsRepositoryProtocol = ShoresideBookingReferenceDetailsRepository(),
		 biometricsAuthenticationService: BiometricAuthenticationService = AppleBiometricAuthenticationService()) {
		self.shoresideBookingReferenceDetailsRepository = shoresideBookingReferenceDetailsRepository
		self.biometricsAuthenticationService = biometricsAuthenticationService
	}

	func execute() async -> Result<ShoresideBookingReferenceDetails, RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCaseError> {
		if biometricsAuthenticationService.isBiometricAuthenticationAvailable() {
			guard let bookingDetails = shoresideBookingReferenceDetailsRepository.shoresideBookingReferenceDetails() else {
				return .failure(.bookingDetailsNotFound)
			}

			let success = await biometricsAuthenticationService.authenticateWithBiometrics()

			return success ? .success(bookingDetails) : .failure(.biometricAuthenticationFailed)
		} else {
			return .failure(.biometricUnavailable)
		}
	}
}

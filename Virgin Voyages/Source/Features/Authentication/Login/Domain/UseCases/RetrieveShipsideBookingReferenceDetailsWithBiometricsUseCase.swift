//
//  RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/29/24.
//

import Foundation

enum RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCaseError: Error {
	case biometricAuthenticationFailed
	case bookingDetailsNotFound
	case biometricUnavailable
}

extension RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase {
	static func create(reason: String) -> RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase {
		let shipsideBookingReferenceDetailsRepository = ShipsideBookingReferenceDetailsRepository()
		let biometricsAuthenticationService = AppleBiometricAuthenticationService(reason: reason)
		return RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase(shipsideBookingReferenceDetailsRepository: shipsideBookingReferenceDetailsRepository,
																			biometricsAuthenticationService: biometricsAuthenticationService)
	}
}

class RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase {
	private var shipsideBookingReferenceDetailsRepository: ShipsideBookingReferenceDetailsRepositoryProtocol
	private var biometricsAuthenticationService: BiometricAuthenticationService

	init(shipsideBookingReferenceDetailsRepository: ShipsideBookingReferenceDetailsRepositoryProtocol = ShipsideBookingReferenceDetailsRepository(),
		 biometricsAuthenticationService: BiometricAuthenticationService = AppleBiometricAuthenticationService()) {
		self.shipsideBookingReferenceDetailsRepository = shipsideBookingReferenceDetailsRepository
		self.biometricsAuthenticationService = biometricsAuthenticationService
	}

	func execute() async -> Result<ShipsideBookingReferenceDetails, RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCaseError> {
		if biometricsAuthenticationService.isBiometricAuthenticationAvailable() {
			guard let bookingDetails = shipsideBookingReferenceDetailsRepository.shipsideBookingReferenceDetails() else {
				return .failure(.bookingDetailsNotFound)
			}

			let success = await biometricsAuthenticationService.authenticateWithBiometrics()

			return success ? .success(bookingDetails) : .failure(.biometricAuthenticationFailed)
		} else {
			return .failure(.biometricUnavailable)
		}
	}
}

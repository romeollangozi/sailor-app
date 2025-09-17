//
//  SetPinUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.7.25.
//

import Foundation

protocol SetPinUseCaseProtocol {
	func execute(pin: String) async throws -> EmptyModel?
}

final class SetPinUseCase: SetPinUseCaseProtocol {
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let setPinRepository: SetPinRepositoryProtocol

	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 setPinRepository: SetPinRepositoryProtocol = SetPinRepository()) {
		self.currentSailorManager = currentSailorManager
		self.setPinRepository = setPinRepository
	}

	func execute(pin: String) async throws -> EmptyModel? {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		guard let response = try await setPinRepository.setPin(input: SetPinInput(pin: pin, reservationGuestId: currentSailor.reservationGuestId)) else { return nil }
		return response
	}
}

//
//  SetPinRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.7.25.
//

import Foundation

protocol SetPinRepositoryProtocol {
	func setPin(input: SetPinInput) async throws -> EmptyModel?
}

final class SetPinRepository: SetPinRepositoryProtocol {

	private let networkService: NetworkServiceProtocol
	private let currentSailorManager: CurrentSailorManager

	init(networkService: NetworkServiceProtocol = NetworkService.create(),
		 currentSailorManager: CurrentSailorManager = CurrentSailorManager()) {
		self.networkService = networkService
		self.currentSailorManager = currentSailorManager
	}

	func setPin(input: SetPinInput) async throws -> EmptyModel? {
		guard let response = try await networkService.setPin(request: input.toRequestBody()) else { return nil }
		return response
	}
}

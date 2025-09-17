//
//  SyncAllAboardTimesUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//

import VVPersist
import Foundation

protocol SyncAllAboardTimesUseCaseProtocol {
	func execute() async throws
}

class SyncAllAboardTimesUseCase: SyncAllAboardTimesUseCaseProtocol {

	private var allAboardTimesService: AllAboardTimesServiceProtocol

	init(
		allAboardTimesService: AllAboardTimesServiceProtocol = AllAboardTimesService()
	) {
		self.allAboardTimesService = allAboardTimesService
	}

	func execute() async throws {
		try await allAboardTimesService.syncAllAboardTimes()
	}
}

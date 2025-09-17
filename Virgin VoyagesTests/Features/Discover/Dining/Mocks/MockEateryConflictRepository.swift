//
//  MockEateryConflictRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import Foundation

@testable import Virgin_Voyages

class MockEateryConflictRepository: EateryConflictRepositoryProtocol {
	var conflictResponse: EateryConflicts?

	func getConflicts(input: EateryConflictsInput) async throws -> EateryConflicts? {
		return conflictResponse
	}
}

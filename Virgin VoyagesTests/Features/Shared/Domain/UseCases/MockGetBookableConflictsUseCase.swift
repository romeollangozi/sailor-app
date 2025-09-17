//
//  MockGetBookableConflictsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import XCTest

@testable import Virgin_Voyages

final class MockGetBookableConflictsUseCase: GetBookableConflictsUseCaseProtocol {
	var mockResponse: [BookableConflictsModel] = []
	
	func execute(input: Virgin_Voyages.BookableConflictsInputModel) async throws -> [Virgin_Voyages.BookableConflictsModel] {
		return mockResponse
	}
}

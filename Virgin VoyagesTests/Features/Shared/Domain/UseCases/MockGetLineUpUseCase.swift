//
//  MockGetLineUpUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.5.25.
//

import XCTest

@testable import Virgin_Voyages

final class MockGetLineUpUseCase: GetLineUpUseCaseProtocol {
	var mockResponse: LineUp = .empty()
	
	func execute(startDateTime: Date?, useCache: Bool) async throws -> Virgin_Voyages.LineUp {
		return mockResponse
	}
}

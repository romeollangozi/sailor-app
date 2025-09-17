//
//  MockGetMySailorsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.4.25.
//

import XCTest

@testable import Virgin_Voyages

final class MockGetMySailorsUseCase: GetMySailorsUseCaseProtocol {
	func execute(useCache: Bool, appointmentLinkId: String?) async throws -> [Virgin_Voyages.SailorModel] {
		guard let response = mockResponse else { throw VVDomainError.genericError }
		
		return response
	}
	
	var mockResponse: [SailorModel]?
}

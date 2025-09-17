//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockCancelAddonRepository: CancelAddonRepositoryProtocol {
    var expectedResult: Result<Bool, VVDomainError>?
    
    func execute(guestIds: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError> {
		return expectedResult ?? .failure(.genericError)
    }
}

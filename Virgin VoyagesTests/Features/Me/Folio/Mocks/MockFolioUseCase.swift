//
//  MockGetFolioUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 13.6.25.
//

import XCTest
@testable import Virgin_Voyages

// MARK: - Mocks

class MockGetFolioUseCase: GetFolioUseCaseProtocol {
   
    var executeResult: Folio?

    func execute() async throws -> Folio {
        return executeResult ?? Folio.empty()
    }
}

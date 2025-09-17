//
//  MockClientTokenUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 1.9.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockClientTokenUseCase: ClientTokenUseCase {
    var tokenToReturn: String?
    override func execute() async -> String? {
        tokenToReturn
    }
}

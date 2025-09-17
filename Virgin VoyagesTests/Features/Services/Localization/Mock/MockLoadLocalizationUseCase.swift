//
//  MockUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

class MockLoadLocalizationUseCase: LoadLocalizationUseCaseProtocol {
    var didLoad = false
    var usedCache: Bool?

    func execute(useCache: Bool) async {
        didLoad = true
        usedCache = useCache

    }
}

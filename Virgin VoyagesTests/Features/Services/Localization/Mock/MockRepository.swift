//
//  MockRepository.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

class MockRepository: ResourcesRepositoryProtocol {
    var shouldFail = false
    var returnedTranslations: [String: String] = [:]

    func fetchStringResources(useCache: Bool) async throws -> [String: String] {
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return returnedTranslations
    }

    func fetchAssetResources(useCache: Bool) async throws -> [String : AssetResource] {
        return [:]
    }
}


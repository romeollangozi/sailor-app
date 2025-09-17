//
//  MockDiskStore.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

class MockDiskStore: StringResourcesDiskStoreProtocol {
    var hasFile = false
    var stored: [String: String] = [:]

    func save(_ translations: [String : String]) throws {
        stored = translations
        hasFile = true
    }

    func load() throws -> [String : String] {
        return stored
    }

    func fileExists() -> Bool {
        return hasFile
    }
}



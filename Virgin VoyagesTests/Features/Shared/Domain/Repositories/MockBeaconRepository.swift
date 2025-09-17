//
//  MockBeaconRepository.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 9/8/25.
//

import XCTest
@testable import Virgin_Voyages

final class MockBeaconRepository: BeaconRepositoryProtocol {
    
    // MARK: - Mock Configuration
    var shouldThrowError = false
    var shouldReturnFalse = false
    var mockBeaconId = "mock-beacon-id-123"
    
    // MARK: - Captured Values for Testing
    var createBeaconRequestInput: CreateBeaconRequestInput?
    var createBeaconCallCount = 0
    var getBeaconIdCallCount = 0
    var clearBeaconIdCallCount = 0
    
    // MARK: - Internal State
    private var storedBeaconId: String?
    
    func createBeacon(input: CreateBeaconRequestInput) async throws -> Bool {
        createBeaconCallCount += 1
        createBeaconRequestInput = input
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        if shouldReturnFalse {
            return false
        }
        
        // Simulate successful beacon creation by storing the mock beacon ID
        storedBeaconId = mockBeaconId
        return true
    }
    
    
    func getBeaconId() -> String {
        getBeaconIdCallCount += 1
        return storedBeaconId ?? ""
    }
    
    func clearBeaconId() {
        clearBeaconIdCallCount += 1
        storedBeaconId = nil
    }
    
}

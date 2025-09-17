//
//  MockShakeForChampagneRepository.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/17/25.
//

import XCTest
@testable import Virgin_Voyages

final class MockShakeForChampagneRepository: ShakeForChampagneRepositoryProtocol {
    
    var shouldThrowError = false
    var mockShakeForChampagne: ShakeForChampagne? = ShakeForChampagne.sample()
    var createShakeForChampagneOrderRequestInput: CreateShakeForChampagneOrderRequestInput? = nil
    var orderId: String? = nil
    
    func getShakeForChampageLandingContent(reservationGuestId: String, orderId: String?) async throws -> ShakeForChampagne? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockShakeForChampagne
    }
    
    func createShakeForChampagneOrder(input: CreateShakeForChampagneOrderRequestInput) async throws -> CreateShakeForChampagneOrderRequestResult {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        createShakeForChampagneOrderRequestInput = input
        
        return .init(orderId: UUID().uuidString)
        
    }
    
    func cancelShakeForChampagneOrder(orderId: String) async throws -> CancelShakeForChampagneOrderRequestResult? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        self.orderId = orderId
        
        return .init(orderId: orderId, message: "test")
        
    }
    
}

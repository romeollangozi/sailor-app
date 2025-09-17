//
//  HomeHealthCheckRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/3/25.
//

import XCTest
@testable import Virgin_Voyages

final class HomeHealthCheckRepositoryMock: HealthCheckRepositoryProtocol {
    
    var shouldThrowError = false
    var mockHealthCheckDetail: HealthCheckDetail? = HealthCheckDetail.sample()
    var updateHealthCheckRequestInput: UpdateHealthCheckDetailRequestInput? = nil
    
    func getHealthCheckDetailContent(reservationGuestId: String,
                                     reservationId: String) async throws -> HealthCheckDetail? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockHealthCheckDetail
        
    }
    
    func updateHealthCheckDetailContent(input: UpdateHealthCheckDetailRequestInput,
                                        reservationGuestId: String,
                                        reservationId: String) async throws -> UpdateHealthCheckDetailRequestResult {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        updateHealthCheckRequestInput = input
        
        return UpdateHealthCheckDetailRequestResult.sample()
    }
    
}

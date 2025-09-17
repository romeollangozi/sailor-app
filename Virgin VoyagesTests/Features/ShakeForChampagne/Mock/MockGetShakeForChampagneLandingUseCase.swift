//
//  MockGetShakeForChampagneLandingUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/20/25.
//

import Foundation
@testable import Virgin_Voyages

class MockGetShakeForChampagneLandingUseCase: GetShakeForChampagneLandingUseCaseProtocol {
    
    var shouldThrowError = false
    var mockShakeForChampagne = ShakeForChampagne.sample()
    
    func execute(orderId: String?) async throws -> ShakeForChampagne {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockShakeForChampagne
        
    }
    
}

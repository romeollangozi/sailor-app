//
//  GetSailorShoreOrShipUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.1.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetSailorShoreOrShipUseCaseTests: XCTestCase {
    
    func testExecuteWhenSailorIsOnShipReturnsIsOnShipTrue() {
        let mockRepository = SailorLocationRepositoryMock(sailorLocation: .ship)
        let useCase = GetSailorShoreOrShipUseCase(lastKnownSailorConnectionLocationRepository: mockRepository)

        let result = useCase.execute()
        
        XCTAssertTrue(result.isOnShip, "Expected isOnShip to be true when sailorLocation is .ship")
    }
    
    func testExecuteWhenSailorIsOnShoreReturnsIsOnShipFalse() {
        let mockRepository = SailorLocationRepositoryMock(sailorLocation: .shore)
        let useCase = GetSailorShoreOrShipUseCase(lastKnownSailorConnectionLocationRepository: mockRepository)
        
        let result = useCase.execute()
        
        XCTAssertFalse(result.isOnShip, "Expected isOnShip to be false when sailorLocation is .shore")
    }
}

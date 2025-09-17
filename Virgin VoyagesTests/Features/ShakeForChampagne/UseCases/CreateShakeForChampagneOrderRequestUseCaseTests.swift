//
//  CreateShakeForChampagneOrderRequestUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/21/25.
//

import XCTest
@testable import Virgin_Voyages

final class CreateShakeForChampagneOrderRequestUseCaseTests: XCTestCase {
    
    private var mockRepository: MockShakeForChampagneRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    
    private var useCase: CreateShakeForChampagneOrderUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockShakeForChampagneRepository()
        mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample())
        useCase = CreateShakeForChampagneOrderUseCase(shakeForChampagneRepository: mockRepository,
                                                             currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        
        let quantity = 1
        let result = try await useCase.execute(quantity: quantity)
        
        let expectedInput = CreateShakeForChampagneOrderRequestInput(reservationGuestId: mockCurrentSailorManager.lastSailor!.reservationGuestId,
                                                                     quantity: quantity)
        
        XCTAssertEqual(expectedInput, mockRepository.createShakeForChampagneOrderRequestInput)
        XCTAssertFalse(result.orderId.isEmpty)
    }
        
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        
        let quantity = 1
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(quantity: quantity)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        
    }
    
}

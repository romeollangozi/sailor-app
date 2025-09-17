//
//  CancelShakeForChampagneOrderUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/22/25.
//

import XCTest
@testable import Virgin_Voyages

final class CancelShakeForChampagneOrderUseCaseTests: XCTestCase {
    
    private var mockRepository: MockShakeForChampagneRepository!
    private var useCase: CancelShakeForChampagneOrderUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockShakeForChampagneRepository()
        useCase = CancelShakeForChampagneOrderUseCase(shakeForChampagneRepository: mockRepository)
    }
    
    override func tearDown() {
        
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        
        let orderId = UUID().uuidString
        
        let result = try await useCase.execute(orderId: orderId)
        
        XCTAssertNotNil(result)
        
    }
    
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        
        let orderId = UUID().uuidString
        
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(orderId: orderId)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
}

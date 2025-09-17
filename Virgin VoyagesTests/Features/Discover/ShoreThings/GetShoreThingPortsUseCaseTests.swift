//
//  GetShoreThingPortsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 15.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetShoreThingPortsUseCaseTests: XCTestCase {
    private var mockShoreThingsRepository: MockShoreThingsRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: GetShoreThingPortsUseCase!
    
    override func setUp() {
        super.setUp()
        mockShoreThingsRepository = MockShoreThingsRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetShoreThingPortsUseCase(
            shoreThingsRepository: mockShoreThingsRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }
    
    override func tearDown() {
        mockShoreThingsRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockShoreThingPorts = ShoreThingPorts.sample()
        let mockSailor = CurrentSailor.sample()
        mockCurrentSailorManager.lastSailor = mockSailor
        mockShoreThingsRepository.mockShoreThingPorts = mockShoreThingPorts
        
        let result = try await useCase.execute()

        XCTAssertEqual(result.items.count, mockShoreThingPorts.items.count)
        XCTAssertEqual(result.leadTime, mockShoreThingPorts.leadTime)
    }
    
    func testExecute_Error() async {
        mockShoreThingsRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}

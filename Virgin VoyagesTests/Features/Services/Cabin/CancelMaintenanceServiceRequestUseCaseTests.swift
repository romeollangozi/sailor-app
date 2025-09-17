//
//  CancelMaintenanceServiceRequestUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 5/2/25.
//

import XCTest
@testable import Virgin_Voyages

final class CancelMaintenanceServiceRequestUseCaseTests: XCTestCase {
    private var useCase: CancelCabinServiceRequestUseCase!
    private var mockCabinServiceRepository: CabinServiceRepositoryMock!
    private var mockCurrentSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockCabinServiceRepository = CabinServiceRepositoryMock()
        mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample().copy(cabinNumber: "1234"))
        useCase = CancelCabinServiceRequestUseCase(
            cabinServiceRepository: mockCabinServiceRepository,
            currentSailorManager: mockCurrentSailorManager
        )
        
    }
    
    override func tearDown() {
        useCase = nil
        mockCabinServiceRepository = nil
        mockCurrentSailorManager = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        let requestId = UUID().uuidString
        let requestName = "CABS"
        
        let result = try await useCase.execute(requestId: requestId, requestName: requestName, isMaintenance: true)
        
        let expectedInput = CancelMaintenanceServiceRequestInput(incidentId: requestId, incidentCategoryCode: requestName, stateroom: mockCurrentSailorManager.lastSailor!.cabinNumber!, reservationGuestId: mockCurrentSailorManager.lastSailor!.reservationGuestId)
                                                           
        
        XCTAssertEqual(expectedInput, mockCabinServiceRepository.cancelMaintenanceServiceRequestInput)
        XCTAssertNotNil(result)
    }
    
    func testExecuteThrowsErrorWhenCabinNumberIsMissing() async throws {
        let requestId = UUID().uuidString
        let requestName = "CABS"
        mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(cabinNumber: "")
        
        do {
            _ = try await useCase.execute(requestId: requestId, requestName: requestName, isMaintenance: true)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        let requestId = UUID().uuidString
        let requestName = "CABS"
        mockCabinServiceRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(requestId: requestId, requestName: requestName, isMaintenance: true)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
}


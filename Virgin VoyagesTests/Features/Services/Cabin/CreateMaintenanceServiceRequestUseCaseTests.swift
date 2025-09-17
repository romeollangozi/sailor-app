//
//  CreateMaintenanceServiceRequestUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 5/1/25.
//

import XCTest
@testable import Virgin_Voyages

final class CreateMaintenanceServiceRequestUseCaseTests: XCTestCase {
    private var useCase: CreateCabinServiceRequestUseCase!
    private var mockCabinServiceRepository: CabinServiceRepositoryMock!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    
    override func setUp() {
        super.setUp()
        mockCabinServiceRepository = CabinServiceRepositoryMock()
        mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample().copy(cabinNumber: "1234"))
        useCase = CreateCabinServiceRequestUseCase(
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
        let requestName = "CABS"
        
        let result = try await useCase.execute(requestName: requestName, isMaintenance: true)
        
        let expectedInput = CreateMaintenanceServiceRequestInput(reservationGuestId: mockCurrentSailorManager.lastSailor!.reservationGuestId, stateroom: mockCurrentSailorManager.lastSailor!.cabinNumber!, incidentCategoryCode: requestName)
        
        XCTAssertEqual(expectedInput, mockCabinServiceRepository.createMaintenanceServiceRequestInput)
        XCTAssertFalse(result.requestId.isEmpty)
    }
    
    func testExecuteThrowsErrorWhenCabinNumberIsMissing() async throws {
        let requestName = "CABS"
        mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(cabinNumber: "")
        
        do {
            _ = try await useCase.execute(requestName: requestName, isMaintenance: true)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        let requestName = "CABS"
        mockCabinServiceRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(requestName: requestName, isMaintenance: true)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

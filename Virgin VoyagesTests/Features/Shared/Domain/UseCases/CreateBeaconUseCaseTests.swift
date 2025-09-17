//
//  CreateBeaconUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 9/8/25.
//

import XCTest
@testable import Virgin_Voyages

final class CreateBeaconUseCaseTests: XCTestCase {
    
    private var mockRepository: MockBeaconRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    
    private var useCase: CreateBeaconUseCase!
    
    override func setUp() {
        super.setUp()
     
        mockRepository = MockBeaconRepository()
        mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample())
        useCase = CreateBeaconUseCase(beaconRepository: mockRepository,
                                      currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        
        let result = try await useCase.execute()
        
        let expectedInput = CreateBeaconRequestInput(reservationGuestId: mockCurrentSailorManager.lastSailor!.reservationGuestId, beaconId: nil)
        
        XCTAssertEqual(expectedInput, mockRepository.createBeaconRequestInput)
    }
        
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
        
    }
    
}

//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetMyVoyageAddOnsUseCaseTests: XCTestCase {
    private var mockMyVoyageAddOnsRepository: MockMyVoyageAddOnsRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: GetMyVoyageAddOnsUseCase!
    
    override func setUp() {
        super.setUp()
        mockMyVoyageAddOnsRepository = MockMyVoyageAddOnsRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetMyVoyageAddOnsUseCase(
            currentSailorManager: mockCurrentSailorManager,
            myVoyageAddOnsRepository: mockMyVoyageAddOnsRepository
        )
    }
    
    override func tearDown() {
        mockMyVoyageAddOnsRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockMyVoyageAddOns = MyVoyageAddOns.sample()
        let mockSailor = CurrentSailor.sample()
        mockCurrentSailorManager.lastSailor = mockSailor
        mockMyVoyageAddOnsRepository.myVoyageAddOns = mockMyVoyageAddOns
        
        let result = try await useCase.execute()

        XCTAssertEqual(result.addOns.count, mockMyVoyageAddOns.addOns.count)
        XCTAssertEqual(result.emptyStatePictogramUrl, mockMyVoyageAddOns.emptyStatePictogramUrl)
        XCTAssertEqual(result.emptyStateText, mockMyVoyageAddOns.emptyStateText)
        XCTAssertEqual(result.title, mockMyVoyageAddOns.title)
    }
    
    func testExecute_Error() async {
        mockMyVoyageAddOnsRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}

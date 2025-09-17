//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.2.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetMyVoyageHeaderUseCaseTests: XCTestCase {
    private var mockVoyageHeaderRepository: MockMyVoyageHeaderRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: GetMyVoyageHeaderUseCase!
    
    override func setUp() {
        super.setUp()
        mockVoyageHeaderRepository = MockMyVoyageHeaderRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetMyVoyageHeaderUseCase(
            myVoyageHeaderRepository: mockVoyageHeaderRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }
    
    override func tearDown() {
        mockVoyageHeaderRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        let mockMyVoyageHeader = MyVoyageHeader.sample()
        let mockSailor = CurrentSailor.sample()
        
        mockCurrentSailorManager.lastSailor = mockSailor
        mockVoyageHeaderRepository.myVoyageHeader = mockMyVoyageHeader
        
        let expectedMyVoyageHeader = MyVoyageHeaderModel(
            imageUrl: mockMyVoyageHeader.imageUrl,
            type: mockMyVoyageHeader.type,
            name: mockMyVoyageHeader.name,
            profileImageUrl: mockMyVoyageHeader.profileImageUrl,
            cabinNumber: mockMyVoyageHeader.cabinNumber,
            lineUpOpeningDateTime: mockMyVoyageHeader.lineUpOpeningDateTime,
            isLineUpOpened: mockMyVoyageHeader.isLineUpOpened,
            buttonSettingsTitle: "Settings",
            buttonMyWalletTitle: "My Wallet",
            buttonLineUpTitle: "View the Line-Up",
            buttonAddonsTitle: "View Available Add-ons",
            emptyStateText: "Book anything that floats your boat now!",
            tabMyAgendaTitle: "My Agenda",
            tabAddOnsTitle: "Add-ons"
        )
        
		let result = try await useCase.execute(useCache: true)
        
        XCTAssertEqual(result, expectedMyVoyageHeader)
    }
    
    func testExecute_Error() async {
        mockVoyageHeaderRepository.shouldThrowError = true
        
        do {
			_ = try await useCase.execute(useCache: true)
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}

//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//
import XCTest
@testable import Virgin_Voyages

class GetAddOnDetailsUseCaseTests: XCTestCase {
    var useCase: MockGetAddonDetailsUseCase!
    
    override func setUp() {
        super.setUp()
        useCase = MockGetAddonDetailsUseCase()
    }
    
    override func tearDown() {
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        // Create test instance without triggering network calls
        let expectedAddonDetails = AddonDetailsModel(addon: AddOnModel(), cms: AddonCMSModel(), guestURL: [])
        useCase.expectedExecuteResult = expectedAddonDetails
        
        let result = try await useCase.execute(addonCode: "123")
        
        XCTAssertEqual(result, expectedAddonDetails, "Expected addon details to match")
    }

    func testExecute_ThrowsError() async {
        useCase.shouldThrowErrorInExecute = true
        
        do {
            _ = try await useCase.execute(addonCode: "123")
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}

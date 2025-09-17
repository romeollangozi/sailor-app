//
//  AddonUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 30.9.24.
//

import XCTest
@testable import Virgin_Voyages

//final class AddonUseCaseTests: XCTestCase {
//    
//    // MARK: - Properties
//    var addonUseCase: AddonUseCase!
//    var mockService: MockGetAddonsService!
//    
//    // MARK: - Setup
//    override func setUp() {
//        super.setUp()
//        mockService = MockGetAddonsService()
//        addonUseCase = AddonUseCase(getAddonsService: mockService)
//    }
//    
//    // MARK: - TearDown
//    override func tearDown() {
//        addonUseCase = nil
//        mockService = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Tests
//    func testGetAddonsSuccess() async {
//        // Given
//        let addon = AddOn(shortDescription: "Test", name: "Test", subtitle: "Test", amount: 10.0, bonusAmount: 0.0, addonCategory: "Test", code: "Test", bonusDescription: "Test", longDescription: "Test", imageURL: "Test", detailReceiptDescription: "Test", currencyCode: "Test", isCancellable: false, isPurchased: true, isBookingEnabled: false, isActionButtonsDisplay: true, isSoldOut: false, isSoldOutText: "Test", isPurchasedText: "Test", closedText: "Test")
//        
//        let expectedAddons = [addOn]
//        let expectedDetails = AddOnDetails(cms: mockService.cms, addons: expectedAddons)
//        mockService.result = .success(expectedDetails)
//        
//        // When
//        let result = await addonUseCase.getAddons()
//        
//        // Then
//        switch result {
//        case .success(let details):
//            XCTAssertEqual(details.addons, expectedAddons)
//            XCTAssertEqual(details.addonsText, "Test")
//            XCTAssertEqual(details.addonsSubtitle, "Test")
//            XCTAssertEqual(details.viewAddonsText, "Test")
//        case .failure:
//            XCTFail("Expected success but got failure")
//        }
//    }
//    
//    func testGetAddonsFailure() async {
//        // Given
//        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
//        mockService.result = .failure(expectedError)
//        
//        // When
//        let result = await addonUseCase.getAddons()
//        
//        // Then
//        switch result {
//        case .success:
//            XCTFail("Expected failure but got success")
//        case .failure(let error as NSError):
//            XCTAssertEqual(error, expectedError)
//        default:
//            XCTFail("Unexpected result type")
//        }
//    }
//}

//
//  AddonViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 30.9.24.
//

//import XCTest
//@testable import Virgin_Voyages
//
//final class AddonViewModelTests: XCTestCase {
//    
//    // MARK: - Properties
//    var viewModel: AddOnsListScreenViewModel!
//    var mockAddonUseCase: MockAddonUseCase!
//    var mockService: MockGetAddonsService!
//    
//    // MARK: - Setup
//    override func setUp() {
//        super.setUp()
//        mockAddonUseCase = MockAddonUseCase()
//        mockService = MockGetAddonsService()
//        viewModel = AddOnsListScreenViewModel(addonsUseCase: mockAddonUseCase, addons: [])
//    }
//    
//    // MARK: - TearDown
//    override func tearDown() {
//        viewModel = nil
//        mockAddonUseCase = nil
//        mockService = nil
//        super.tearDown()
//    }
//    
//    // MARK: - Initialization Tests
//    func testInitWithDefaultValues() {
//        // Given
//        let viewModel = AddOnsListScreenViewModel(addonsUseCase: mockAddonUseCase, addons: [])
//        
//        // Then
//        XCTAssertEqual(viewModel.addons, [])
//        XCTAssertEqual(viewModel.addonsText, "")
//        XCTAssertEqual(viewModel.addonsSubtitle, "")
//        XCTAssertEqual(viewModel.viewAddonsText, "")
//        XCTAssertEqual(viewModel.screenState, .loading)
//    }
//    
//    func testInitWithCustomValues() {
//        // Given
//        let addOn = AddOn(shortDescription: "Test", name: "Test", subtitle: "Test", amount: 10.0, bonusAmount: 0.0, addonCategory: "Test", code: "Test", bonusDescription: "Test", longDescription: "Test", imageURL: "Test", detailReceiptDescription: "Test", currencyCode: "Test", isCancellable: false, isPurchased: true, isBookingEnabled: false, isActionButtonsDisplay: true, isSoldOut: false, isSoldOutText: "Test", isPurchasedText: "Test", closedText: "Test")
//        
//        let customAddons = [addOn]
//
//        let viewModel = AddOnsListScreenViewModel(
//            addonsUseCase: mockAddonUseCase,
//            addons: customAddons,
//            addonsText: "Custom Addons Text",
//            addonsSubtitle: "Custom Subtitle",
//            viewAddonsText: "Custom View Text",
//            screenState: .content
//        )
//        
//        // Then
//        XCTAssertEqual(viewModel.addons, customAddons)
//        XCTAssertEqual(viewModel.addonsText, "Custom Addons Text")
//        XCTAssertEqual(viewModel.addonsSubtitle, "Custom Subtitle")
//        XCTAssertEqual(viewModel.viewAddonsText, "Custom View Text")
//        XCTAssertEqual(viewModel.screenState, .content)
//    }
//    
//    // MARK: - onAppear Tests
//    
//    func testOnAppearSuccess() async {
//        // Given
//        let addOn = AddOn(shortDescription: "Test", name: "Test", subtitle: "Test", amount: 10.0, bonusAmount: 0.0, addonCategory: "Test", code: "Test", bonusDescription: "Test", longDescription: "Test", imageURL: "Test", detailReceiptDescription: "Test", currencyCode: "Test", isCancellable: false, isPurchased: true, isBookingEnabled: false, isActionButtonsDisplay: true, isSoldOut: false, isSoldOutText: "Test", isPurchasedText: "Test", closedText: "Test")
//        
//        let expectedAddons = [addOn]
//        let addonDetails = AddOnDetails(
//            cms: mockService.cms, addons: expectedAddons
//        )
//        
//        mockAddonUseCase.result = .success(addonDetails)
//        
//        // When
//        await viewModel.onAppear()
//        
//        // Then
//        XCTAssertEqual(viewModel.addons, expectedAddons)
//        XCTAssertEqual(viewModel.addonsText, "Test")
//        XCTAssertEqual(viewModel.addonsSubtitle, "Test")
//        XCTAssertEqual(viewModel.viewAddonsText, "Test")
//        XCTAssertEqual(viewModel.screenState, .content)
//    }
//    
//    func testOnAppearFailure() async {
//        // Given
//        let expectedError = NSError(domain: "Error", code: 1, userInfo: nil)
//        mockAddonUseCase.result = .failure(expectedError)
//        
//        // When
//        await viewModel.onAppear()
//        
//        // Then
//        XCTAssertEqual(viewModel.screenState, .error)
//    }
//}

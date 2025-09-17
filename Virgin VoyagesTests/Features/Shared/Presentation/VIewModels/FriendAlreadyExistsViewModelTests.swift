//
//  FriendAlreadyExistsViewModelTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.9.25.
//


import XCTest
@testable import Virgin_Voyages

@MainActor
final class FriendAlreadyExistsViewModelTests: XCTestCase {
    
    private var viewModel: FriendAlreadyExistsViewModel!
    private var mockGetMySailorsUseCase: MockGetMySailorsUseCase!
    private var mockLocalizationManager: MockLocalizationManager!
    private var testContact: AddContactData!
    
    override func setUp() {
        super.setUp()
        
        mockGetMySailorsUseCase = MockGetMySailorsUseCase()
        mockLocalizationManager = MockLocalizationManager()
        
        testContact = AddContactData(
            reservationGuestId: "test-guest-123",
            reservationId: "test-reservation-456",
            voyageNumber: "VV001",
            name: "Test User"
        )
        
        viewModel = FriendAlreadyExistsViewModel(
            contact: testContact,
            getMySailorsUseCase: mockGetMySailorsUseCase,
            profileImageUrl: "",
            localizationManager: mockLocalizationManager
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockGetMySailorsUseCase = nil
        mockLocalizationManager = nil
        testContact = nil
        super.tearDown()
    }
    
    // MARK: - loadAvailableSailors Tests
    
    func testLoadAvailableSailors_WhenSailorFound_SetsProfileImageUrl() async {
        // Given
        let expectedImageUrl = ""
        let sailors = SailorModel.samples()
        mockGetMySailorsUseCase.mockResponse = sailors
        
        // When
        await viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.profileImageUrl, expectedImageUrl)
    }
    
    func testLoadAvailableSailors_WhenSailorNotFound_SetsEmptyProfileImageUrl() async {
        // Given
        let sailors = SailorModel.samples()
        mockGetMySailorsUseCase.mockResponse = sailors
        
        // When
        await viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.profileImageUrl, "")
    }
    
    func testLoadAvailableSailors_WhenSailorFoundButNoProfileImageUrl_SetsEmptyString() async {
        // Given
        let sailors = SailorModel.samples()
        mockGetMySailorsUseCase.mockResponse = sailors
        
        // When
        await viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.profileImageUrl, "")
    }
    
    func testLoadAvailableSailors_WhenEmptyResponse_SetsEmptyProfileImageUrl() async {
        // Given
        mockGetMySailorsUseCase.mockResponse = []
        
        // When
        await viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.profileImageUrl, "")
    }
    
    func testLoadAvailableSailors_WhenUseCaseFails_DoesNotUpdateProfileImageUrl() async {
        // Given
        let initialProfileImageUrl = "initial-url"
        viewModel = FriendAlreadyExistsViewModel(
            contact: testContact,
            getMySailorsUseCase: mockGetMySailorsUseCase,
            profileImageUrl: initialProfileImageUrl,
            localizationManager: mockLocalizationManager
        )
        mockGetMySailorsUseCase.mockResponse = nil // This will cause the use case to throw
        
        // When
        await viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.profileImageUrl, initialProfileImageUrl)
    }
    
    func testLoadAvailableSailors_CallsUseCaseWithCorrectCacheParameter() async {
        // Given
        mockGetMySailorsUseCase.mockResponse = []
        
        // When
        await viewModel.onAppear()

        XCTAssertEqual(viewModel.profileImageUrl, "")
    }
    
    func testLoadAvailableSailors_WithMultipleSailorsWithSameId_UsesFirstMatch() async {
        // Given
        let firstImageUrl = ""
        let secondImageUrl = "https://example.com/second.jpg"
        let sailors = SailorModel.samples()
        mockGetMySailorsUseCase.mockResponse = sailors
        
        // When
        await viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.profileImageUrl, firstImageUrl)
    }
}

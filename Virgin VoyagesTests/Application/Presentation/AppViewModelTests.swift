//
//  AppViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 8/18/25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor class AppViewModelTests: XCTestCase {
    
    var sut: AppViewModel!
    var mockGetUserApplicationStatusUseCase: MockGetUserApplicationStatusUseCase!
    var mockDeepLinkNotificationDispatcher: MockDeepLinkNotificationDispatcher!
    var mockMotionDetectionService: MotionDetectionServiceProtocol!
    var mockUserShoreShipLocationEventsNotificationService: UserShoreShipLocationEventsNotificationService!
    var mockAuthenticationService: MockAuthenticationService!
    
    @MainActor override func setUp() {
        super.setUp()
        
        mockGetUserApplicationStatusUseCase = MockGetUserApplicationStatusUseCase()
        mockDeepLinkNotificationDispatcher = MockDeepLinkNotificationDispatcher()
        mockMotionDetectionService = MockMotionDetectionService()
        mockUserShoreShipLocationEventsNotificationService = MockUserShoreShipLocationEventsNotificationService()
        mockAuthenticationService = MockAuthenticationService()
        
        sut = AppViewModel(getUserApplicationStatusUseCase: mockGetUserApplicationStatusUseCase,
                           deepLinkNotificationDispatcher: mockDeepLinkNotificationDispatcher,
                           motionDetectionService: mockMotionDetectionService,
                           userShoreShipLocationEventsNotificationService: mockUserShoreShipLocationEventsNotificationService,
                           authenticationService: mockAuthenticationService)
    }
    
    @MainActor override func tearDown() {
        mockGetUserApplicationStatusUseCase = nil
        mockDeepLinkNotificationDispatcher = nil
        mockMotionDetectionService = nil
        mockUserShoreShipLocationEventsNotificationService = nil
        mockAuthenticationService = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests for preloadUserApplicationStatus()
    
    func testPreloadUserApplicationStatus_Success() async {
        // Given
        let expectedStatus = UserApplicationStatus.userLoggedInWithReservation
        mockGetUserApplicationStatusUseCase.result = expectedStatus
        
        // When
        await sut.preloadUserApplicationStatus()
        
        // Then
        XCTAssertEqual(mockGetUserApplicationStatusUseCase.executeCallCount, 1)
    }
    
    func testPreloadUserApplicationStatus_Failure() async {
        // Given
        mockGetUserApplicationStatusUseCase.shouldThrowError = true
        mockGetUserApplicationStatusUseCase.errorToThrow = VVDomainError.genericError
        
        // When
        await sut.preloadUserApplicationStatus()
        
        // Then
        XCTAssertEqual(mockGetUserApplicationStatusUseCase.executeCallCount, 1)
    }
    
    // MARK: - Tests for handleExternalURL()
    
    func testHandleExternalURL_UserLoggedIn() async {
        // Given
        let testURL = URL(string: "https://example.com/deeplink")!
        let expectedStatus = UserApplicationStatus.userLoggedInWithReservation
        
        // Setup mocks
        mockGetUserApplicationStatusUseCase.result = expectedStatus
        
        // Pre-load user status
        await sut.preloadUserApplicationStatus()
        
        // When
        sut.handleExternalURL(url: testURL)
        
        // Give some time for the async Task to complete
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Then
        XCTAssertEqual(mockDeepLinkNotificationDispatcher.didDispatchCount, 1)
    }
    
    
    // MARK: - Tests for handleExternalURLNavigation()
    
    func testHandleExternalURLNavigation_WithExistingUserStatus() async {
        // Given
        let testType = "testType"
        let testData = "testData"
        let expectedStatus = UserApplicationStatus.userLoggedInWithReservation
        
        mockGetUserApplicationStatusUseCase.result = expectedStatus
        await sut.preloadUserApplicationStatus() // Pre-load status
        
        // When
        await sut.handleExternalURLNavigation(type: testType, data: testData)
        
        // Then
        XCTAssertEqual(mockDeepLinkNotificationDispatcher.didDispatchCount, 1)
        XCTAssertEqual(mockGetUserApplicationStatusUseCase.executeCallCount, 1)
    }
    
    func testHandleExternalURLNavigation_WithoutExistingUserStatus() async {
        // Given
        let testType = "testType"
        let testData = "testData"
        let expectedStatus = UserApplicationStatus.userLoggedInWithReservation
        
        mockGetUserApplicationStatusUseCase.result = expectedStatus
        
        // When
        await sut.handleExternalURLNavigation(type: testType, data: testData)
        
        // Then
        XCTAssertEqual(mockDeepLinkNotificationDispatcher.didDispatchCount, 1)
        XCTAssertEqual(mockGetUserApplicationStatusUseCase.executeCallCount, 1)
    }
    
}

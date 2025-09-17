//
//  ClaimBookingSelectSailorViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.2.25.
//

import XCTest
@testable import Virgin_Voyages

class ClaimBookingSelectSailorViewModelTests: XCTestCase {
    
    // Mock Data
    var viewModel: ClaimBookingSelectSailorViewModel!
    var mockGetUserProfileUseCase: MockGetUserProfileUseCase!
    var mockCoordinator: MockCoordinator!

    override func setUp() {
        super.setUp()
        
        mockGetUserProfileUseCase = MockGetUserProfileUseCase()
        mockCoordinator = MockCoordinator()
        
        let sampleGuestDetails = [
            ClaimBookingGuestDetails(
                name: "John",
                lastName: "Doe",
                reservationNumber: "12345",
                email: "john.doe@example.com",
                birthDate: "01-01-1990".fromMMDDYYYYToDate(),
                reservationGuestID: "GUEST1",
                genderCode: "M"
            ),
            ClaimBookingGuestDetails(
                name: "Jane",
                lastName: "Smith",
                reservationNumber: "XYZ789",
                email: "jane.smith@example.com",
                birthDate: nil,
                reservationGuestID: "GUEST2",
                genderCode: "F"
            )
        ]
        
        viewModel = ClaimBookingSelectSailorViewModel(
            appCoordinator: mockCoordinator,
            bookingReferenceNumber: "12345",
            guestDetails: sampleGuestDetails,
            getUserProfileUseCase: mockGetUserProfileUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockGetUserProfileUseCase = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    func testAutoSelectCurrentUser_MatchingUsers() async {
        // Arrange: Set up the mock user profile with a matching user
        let mockUserProfile = UserProfile.mockUser(withLastname: "Doe", reservationNumber: "12345", birthDateString: "01-01-1990")
        mockGetUserProfileUseCase.mockUserProfile = mockUserProfile
        
        // Act: Trigger the autoSelectCurrentUser function
        await viewModel.autoSelectCurrentUser()
        
        // Assert: Check if the selectedGuest is correctly set
        XCTAssertNotNil(viewModel.selectedGuest, "Selected guest should not be nil")
        XCTAssertEqual(viewModel.selectedGuest?.lastName, mockUserProfile.lastName, "The selected guest's lastName should match the mock user profile's lastName")
        XCTAssertEqual(viewModel.selectedGuest?.reservationNumber, mockUserProfile.bookingInfo.reservationNumber, "The selected guest's reservationNumber should match the mock user profile's reservationNumber")
        XCTAssertEqual(viewModel.selectedGuest?.birthDate?.toMonthDayYear(), mockUserProfile.birthDate, "The selected guest's birthDate string should match the mock user profile's birthDate string")
    }
    
    func testAutoSelectCurrentUser_NoMatchingUser() async {
        // Arrange: Set up the mock user profile with a non-matching user
        let mockUserProfile = UserProfile.mockUser(withLastname: "NonExist", reservationNumber: "12345", birthDateString: "01-01-1990")
        mockGetUserProfileUseCase.mockUserProfile = mockUserProfile
        
        // Act: Trigger the autoSelectCurrentUser function
        await viewModel.autoSelectCurrentUser()
        
        // Assert: Check if the selectedGuest is nil when no matching user is found
        XCTAssertNil(viewModel.selectedGuest, "Selected guest should be nil when no matching email is found")
    }
}

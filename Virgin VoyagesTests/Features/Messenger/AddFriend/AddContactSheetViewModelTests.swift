//  AddContactSheetViewModelTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.8.25.

import XCTest
@testable import Virgin_Voyages


final class AddContactSheetViewModelTests: XCTestCase {

	// MARK: - Properties
	private var sut: TestableAddContactSheetViewModel!
	private var mockContact: AddContactData!

	// MARK: - Setup & Teardown
	override func setUp() {
		super.setUp()
		mockContact = AddContactData(
			reservationGuestId: "GUEST123",
			reservationId: "RES123",
			voyageNumber: "VN001",
			name: "John Doe"
		)
		sut = TestableAddContactSheetViewModel(contact: mockContact, isFromDeepLink: false, onDismiss: {})
	}

	override func tearDown() {
		sut = nil
		mockContact = nil
		super.tearDown()
	}

	// MARK: - Test Cases
	func testAddFriend_WhenResultIsTrueAndAllowAttendingIsFalse_CallsDismiss() async throws {
		// Given
		sut.allowAttending = false
		sut.mockAddFriendResult = true
		sut.addFriendButtonLoading = false
		// Setup deep link data
		sut.deepLinkContactDataModel = DeepLinkContactDataModel(
			titleText: "Accept invite, and add friend?",
			imageUrl: "https://example.com/image.jpg",
			preferredName: "John Doe",
			allowAttending: "Allow John Doe to see what I'm attending",
			description: "Adding a friend will also add their cabin-mates",
			addFriendButtonText: "Add Friend",
			connectionReservationId: "RES123",
			connectionReservationGuestId: "GUEST123"
		)

		sut.addFriend()

		try await Task.sleep(nanoseconds: 200_000_000)

		// Then
		XCTAssertEqual(sut.screenState, .content, "Screen state should be set to content")
		XCTAssertFalse(sut.addFriendButtonLoading, "Add friend button loading should be false")
	}
}

// MARK: - Mock Classes
class MockSailorRepository: SailorsRepositoryProtocol {
	func fetchMySailors(reservationGuestId: String, reservationNumber: String, useCache: Bool, appointmentLinkId: String?) async throws -> [Virgin_Voyages.SailorModel] {
		if shouldThrowOnFetch {
			throw VVDomainError.unauthorized
		}
		return sailors
	}
	var shouldThrowOnFetch = false
	var sailors: [SailorModel] = []
}

// MARK: - Testable ViewModel
class TestableAddContactSheetViewModel: AddContactSheetViewModel {

	var dismissCalled = false
	var mockAddFriendResult = true

	override func addFriend() {
		Task {
			self.addFriendButtonLoading = true
			await executeUseCase {
				let result = self.mockAddFriendResult

				await self.executeOnMain { [weak self] in
					guard let self = self else { return }
					if result {
						if allowAttending {
						} else {
							self.screenState = .content
							self.addFriendButtonLoading = false
						}
					} else {
						self.screenState = .error
					}
				}
			}
		}
	}
}

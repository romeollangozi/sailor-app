//
//  PurchasedAddonDetailsViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class PurchasedAddonDetailsViewModelTests: XCTestCase {

    var viewModel: PurchasedAddonDetailsViewModel!
    var mockCancelUseCase: MockCancelAddonUseCase!
    var mockBookingEventsService: MockBookingEventsNotificationService!

    override func setUp() {
        super.setUp()
        mockCancelUseCase = MockCancelAddonUseCase()
        mockBookingEventsService = MockBookingEventsNotificationService()

        viewModel = PurchasedAddonDetailsViewModel(
            addonCode: "A1",
            cancelAddonUseCase: mockCancelUseCase,
            bookingEventsNotificationService: mockBookingEventsService
        )
    }

    override func tearDown() {
        viewModel = nil
        mockCancelUseCase = nil
        mockBookingEventsService = nil
        super.tearDown()
    }

    // MARK: - confirmCancellationHeading

    func testConfirmCancellationHeading_ReplacesRefundAmountCorrectly() {
        // Given
        let amountPerGuest: Double = 100.0
        let numberOfGuests = 2
        viewModel.addonDetailsModel.confirmationHeading = "Refund amount: {refundAmount}"
        viewModel.addonDetailsModel.amount = amountPerGuest
        viewModel.addonDetailsModel.currencyCode = "USD"
        viewModel.showConfirmCancelation = (true, false, numberOfGuests)

        // When
        let heading = viewModel.confirmCancellationHeading

        // Then
        XCTAssertEqual(heading, "Refund amount: $ \(amountPerGuest * Double(numberOfGuests))")
    }

    // MARK: - prepearForCancellation

    func testPrepareForCancellation_SingleGuest() {
        // Given
        viewModel.addonDetailsModel.guestId = "guest_1"

        // When
        viewModel.prepearForCancellation(confirmation: true, forSingleGuest: true)

        // Then
        XCTAssertTrue(viewModel.showConfirmCancelation.confirmation)
        XCTAssertTrue(viewModel.showConfirmCancelation.forSingleGuest)
        XCTAssertEqual(viewModel.showConfirmCancelation.numberOfGuests, 1)
    }

    func testPrepareForCancellation_AllGuests() {
        // Given
        viewModel.addonDetailsModel.guests = ["guest_1", "guest_2"]

        // When
        viewModel.prepearForCancellation(confirmation: true, forSingleGuest: false)

        // Then
        XCTAssertTrue(viewModel.showConfirmCancelation.confirmation)
        XCTAssertFalse(viewModel.showConfirmCancelation.forSingleGuest)
        XCTAssertEqual(viewModel.showConfirmCancelation.numberOfGuests, 2)
    }

    // MARK: - didCancelAddon

    func testDidCancelAddon_PublishesCancellationEvent() {
        // When
        viewModel.didCancelAddon()

        // Then
        XCTAssertEqual(mockBookingEventsService.publishedEvents.count, 1)
        XCTAssertEqual(mockBookingEventsService.publishedEvents.first, .userDidCancelABooking(appointmentLinkId: "A1"))
    }
}

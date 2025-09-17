//
//  BookingSummaryScreenViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 11.6.25.
//


import XCTest
@testable import Virgin_Voyages

// MARK: BookingSummaryScreenViewModelTests
final class BookingSummaryScreenViewModelTests: XCTestCase {
	private var viewModel: BookingSummaryScreenViewModel!

	private func makeViewModel(with inputModel: BookingSummaryInputModel) -> BookingSummaryScreenViewModel {
		BookingSummaryScreenViewModel(inputModel: inputModel)
	}
}

// MARK: BookingConfirmationSecondaryButtonTitleTests
extension BookingSummaryScreenViewModelTests {
	func testBookingConfirmationSecondaryButtonTitle_ShouldBeNil_WhenBookableTypeIsAddOns() {
		let inputModel = BookingSummaryInputModel(
            appointmentId: "",
			appointmentLinkId: nil,
			slot: nil,
			name: "Test Activity",
			location: nil,
			sailors: [],
			previousBookedSailors: [],
			totalPrice: 100,
			currencyCode: "USD",
			activityCode: "ACT123",
			categoryCode: "CAT123",
			bookableImageName: nil,
			bookableType: .addOns,
			addonSellType: nil,
			categoryString: nil,
			itemDescriptionString: nil
		)

		viewModel = makeViewModel(with: inputModel)
		XCTAssertNil(viewModel.bookingConfirmationSecondaryButtonTitle)
	}

	func testBookingConfirmationSecondaryButtonTitle_ShouldBeViewAgenda_WhenBookableTypeIsNotAddOns() {
		let inputModel = BookingSummaryInputModel(
            appointmentId: "",
			appointmentLinkId: nil,
			slot: nil,
			name: "Test Activity",
			location: nil,
			sailors: [],
			previousBookedSailors: [],
			totalPrice: 100,
			currencyCode: "USD",
			activityCode: "ACT123",
			categoryCode: "CAT123",
			bookableImageName: nil,
			bookableType: .entertainment,
			addonSellType: nil,
			categoryString: nil,
			itemDescriptionString: nil
		)

		viewModel = makeViewModel(with: inputModel)
		XCTAssertEqual(viewModel.bookingConfirmationSecondaryButtonTitle, "View in your Agenda")
	}
}

// MARK: bookableDateTests
extension BookingSummaryScreenViewModelTests {
	func testBookableDate_ShouldReturnSlotDate_WhenSlotIsProvided() {
		let date = Date(timeIntervalSince1970: 1_723_040_000)
		let slot = Slot.sample().copy(startDateTime: date)

		let inputModel = BookingSummaryInputModel(
            appointmentId: "",
			appointmentLinkId: nil,
			slot: slot,
			name: "Test Activity",
			location: nil,
			sailors: [],
			previousBookedSailors: [],
			totalPrice: 100,
			currencyCode: "USD",
			activityCode: "ACT123",
			categoryCode: "CAT123",
			bookableImageName: nil,
			bookableType: .entertainment,
			addonSellType: nil,
			categoryString: nil,
			itemDescriptionString: nil
		)

		viewModel = makeViewModel(with: inputModel)
		XCTAssertEqual(viewModel.bookableDate, date)
	}

	func testBookableDate_ShouldReturnNow_WhenSlotIsNil() {
		let inputModel = BookingSummaryInputModel(
            appointmentId: "",
			appointmentLinkId: nil,
			slot: nil,
			name: "Test Activity",
			location: nil,
			sailors: [],
			previousBookedSailors: [],
			totalPrice: 100,
			currencyCode: "USD",
			activityCode: "ACT123",
			categoryCode: "CAT123",
			bookableImageName: nil,
			bookableType: .entertainment,
			addonSellType: nil,
			categoryString: nil,
			itemDescriptionString: nil
		)

		viewModel = makeViewModel(with: inputModel)
		XCTAssertLessThanOrEqual(abs(viewModel.bookableDate.timeIntervalSinceNow), 1.0)
	}

    func testOnPreviewAgendaTapped_SetsFlagToTrue() {
        let inputModel = BookingSummaryInputModel(
            appointmentId: "",
            appointmentLinkId: nil,
            slot: nil,
            name: "Activity Name",
            location: nil,
            sailors: [],
            previousBookedSailors: [],
            totalPrice: nil,
            currencyCode: "USD",
            activityCode: "CODE",
            categoryCode: "CAT",
            bookableImageName: nil,
			bookableType: .entertainment,
			addonSellType: nil,
            categoryString: nil,
            itemDescriptionString: nil
        )
        let viewModel = BookingSummaryScreenViewModel(inputModel: inputModel)

        viewModel.showPreviewMyAgendaSheet = false
        viewModel.onPreviewAgendaTapped()

        XCTAssertTrue(viewModel.showPreviewMyAgendaSheet)
    }

    func testOnPreviewMyAgendaDismiss_SetsFlagToFalse() {
        let inputModel = BookingSummaryInputModel(
            appointmentId: "",
            appointmentLinkId: nil,
            slot: nil,
            name: "Activity Name",
            location: nil,
            sailors: [],
            previousBookedSailors: [],
            totalPrice: nil,
            currencyCode: "USD",
            activityCode: "CODE",
            categoryCode: "CAT",
            bookableImageName: nil,
			bookableType: .entertainment,
			addonSellType: nil,
            categoryString: nil,
            itemDescriptionString: nil
        )
        let viewModel = BookingSummaryScreenViewModel(inputModel: inputModel)
        
        viewModel.showPreviewMyAgendaSheet = true
        viewModel.onPreviewMyAgendaDismiss()
        
        XCTAssertFalse(viewModel.showPreviewMyAgendaSheet)
    }
}

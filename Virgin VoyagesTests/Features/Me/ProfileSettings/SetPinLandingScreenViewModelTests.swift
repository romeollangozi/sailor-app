//
//  SetPinLandingScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.7.25.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

class SetPinLandingScreenViewModelTests: XCTestCase {

	var sut: SetPinLandingScreenViewModel!
	var mockLocalizationManager: MockLocalizationManager!

	override func setUp() {
		super.setUp()
		mockLocalizationManager = MockLocalizationManager(preloaded: [
			.setPinTitle: "Set PIN",
			.setPinSubtitle: "Create your secure PIN",
			.changePinButton: "Change PIN",
			.casinoEditSuccessHeading: "Success!",
			.casinoEditSuccessBody: "Your PIN has been updated successfully"
		])

		sut = SetPinLandingScreenViewModel(
			localizationManager: mockLocalizationManager
		)
	}

	override func tearDown() {
		sut = nil
		mockLocalizationManager = nil
		super.tearDown()
	}

	func testInitialization_ShouldSetupInitialStateAndLocalizedLabels() {
		// Then - Verify initial state
		XCTAssertFalse(sut.showSuccessMessage, "Should not show success message initially")

		// Verify labels are properly localized
		let labels = sut.labels
		XCTAssertEqual(labels.title, "Set PIN", "Title should be localized")
		XCTAssertEqual(labels.subtitle, "Create your secure PIN", "Subtitle should be localized")
		XCTAssertEqual(labels.changePinButton, "Change PIN", "Change PIN button should be localized")
		XCTAssertEqual(labels.successMessageTitle, "Success!", "Success message title should be localized")
		XCTAssertEqual(labels.successMessageBody, "Your PIN has been updated successfully", "Success message body should be localized")
	}

	func testButtonActions_ShouldManageStateCorrectly() {
		// Given - Set success message to true manually to test reset functionality
		sut.showSuccessMessage = true
		XCTAssertTrue(sut.showSuccessMessage, "Success message should be shown initially for test")

		// When - Test onChangePinButtonTap
		sut.onChangePinButtonTap()

		// Then
		XCTAssertFalse(sut.showSuccessMessage, "Should reset success message when change PIN button is tapped")

		// Given - Set success message to true again
		sut.showSuccessMessage = true
		XCTAssertTrue(sut.showSuccessMessage, "Success message should be shown again for test")

		// When - Test onBackButtonTap
		sut.onBackButtonTap()

		// Then
		XCTAssertFalse(sut.showSuccessMessage, "Should reset success message when back button is tapped")
	}

	func testStateConsistencyAndLocalization_ShouldMaintainProperBehavior() {
		// Given - Initial state
		XCTAssertFalse(sut.showSuccessMessage, "Should start with success message hidden")

		// When - Manually set success message state
		sut.showSuccessMessage = true
		XCTAssertTrue(sut.showSuccessMessage, "Should be able to show success message")

		// When - Test multiple button taps
		sut.onChangePinButtonTap()
		XCTAssertFalse(sut.showSuccessMessage, "First button tap should reset message")

		sut.showSuccessMessage = true
		sut.onBackButtonTap()
		XCTAssertFalse(sut.showSuccessMessage, "Second button tap should reset message")

		// Verify localization consistency throughout state changes
		let labels = sut.labels
		XCTAssertEqual(labels.title, "Set PIN", "Localized strings should remain consistent")
		XCTAssertEqual(labels.successMessageTitle, "Success!", "Success message title should remain consistent")
		XCTAssertEqual(labels.changePinButton, "Change PIN", "Change PIN button label should remain consistent")

		// Verify localization manager integration
		XCTAssertEqual(mockLocalizationManager.getString(for: .setPinTitle), "Set PIN")
		XCTAssertEqual(mockLocalizationManager.getString(for: .changePinButton), "Change PIN")
	}
}

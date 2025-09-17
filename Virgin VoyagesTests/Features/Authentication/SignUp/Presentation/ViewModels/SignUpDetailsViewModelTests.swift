//
//  SignUpDetailsViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 1.9.24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

@MainActor
final class SignUpDetailsViewModelTests: XCTestCase {

    var viewModel: SignUpDetailsViewModelProtocol!
    var inputModel: SignUpInputModel!

    override func setUpWithError() throws {
        // Default valid model
        inputModel = SignUpInputModel(
            email: "test@example.com",
            firstName: "Joseph",
            lastName: "Richard",
            dateOfBirth: DateComponents(year: 2000, month: 1, day: 1),
            receiveEmails: true
        )
        viewModel = SignUpDetailsViewModel(model: inputModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        inputModel = nil
    }

    // MARK: - Button enablement

    func testValidInputEnablesNextButton() throws {
        // Arrange: ensure valid names + valid DOB
        inputModel.firstName = "Richard"
        inputModel.lastName  = "Joseph"
        inputModel.dateOfBirth = DateComponents(year: 2000, month: 1, day: 1)
        viewModel.signUpInputModel = inputModel

        // Act
        let disabled = viewModel.nextButtonDisabled

        // Assert
        XCTAssertFalse(disabled, "Next button should be enabled for valid input")
    }

    func testNextButtonDisabledForInvalidName() throws {
        // Arrange: invalid first name
        inputModel.firstName = ""
        inputModel.lastName  = "Joseph"
        viewModel.signUpInputModel = inputModel

        // Act
        let disabled = viewModel.nextButtonDisabled

        // Assert
        XCTAssertTrue(disabled, "Next button should be disabled for invalid name")
    }

    // MARK: - DOB validation / messaging

    func testInvalidDateOfBirthShowsError() throws {
        // Arrange: under 14 years old
        inputModel.dateOfBirth = DateComponents(year: 2020, month: 1, day: 1)
        viewModel.signUpInputModel = inputModel

        // Act
        let dobError = viewModel.dateOfBirthError

        // Assert
        XCTAssertNotNil(dobError, "Error should be shown for invalid date of birth (under 14)")
    }

    func testValidDateOfBirth() throws {
        // Arrange
        inputModel.dateOfBirth = DateComponents(year: 2000, month: 1, day: 1)
        viewModel.signUpInputModel = inputModel

        // Act
        let valid = viewModel.isValidDate()

        // Assert
        XCTAssertTrue(valid, "Date of birth should be valid (>= 13 years)")
    }

    func testInvalidDateOfBirth() throws {
        // Arrange: under 14 years old
        inputModel.dateOfBirth = DateComponents(year: 2020, month: 1, day: 1)
        viewModel.signUpInputModel = inputModel   // 🔧 FIX: assign back before asserting

        // Act
        let valid = viewModel.isValidDate()

        // Assert
        XCTAssertFalse(valid, "Date of birth should be invalid (< 13 years)")
    }

    func testDateOfBirthErrorIsNilWhenNotFullySpecified() throws {
        // Arrange: empty DateComponents (not fully specified)
        inputModel.dateOfBirth = DateComponents()
        viewModel.signUpInputModel = inputModel

        // Act
        let dobError = viewModel.dateOfBirthError

        // Assert
        XCTAssertNil(dobError, "dateOfBirthError should be nil when date is not fully specified")
    }

    func testShowClarificationTrueWhenDobInvalid() throws {
        // Arrange: underage means computed error should be "" (per VM), so showClarification = true
        inputModel.dateOfBirth = DateComponents(year: 2020, month: 1, day: 1)
        viewModel.signUpInputModel = inputModel

        // Act
        let show = viewModel.showClarification

        // Assert
        XCTAssertTrue(show, "showClarification should be true when DOB is invalid/underage")
    }

    func testClarificationString() throws {
        // Act
        let text = viewModel.clarification

        // Assert
        XCTAssertEqual(
            text,
            "Accounts can only be established for sailors over the age of 13, so if you don’t remember a world without social media, we’re going to have to ask you to leave",
            "Clarification text should match expected copy"
        )
    }

    // MARK: - Name field error presentation (focus loss + single message)

    func testFirstNameFocusLossSetsFirstNameErrorAndNameError() {
        viewModel.signUpInputModel.firstName = ""
        // Simulate focus loss (old=true → new=false)
        viewModel.onFirstNameFocusChanged(oldValue: true, newValue: false)

        XCTAssertNotNil(viewModel.firstNameError)
        XCTAssertEqual(viewModel.nameError, viewModel.firstNameError)
        XCTAssertNil(viewModel.lastNameError)
    }

    func testLastNameFocusLossSetsLastNameErrorAndNameError() {
        viewModel.signUpInputModel.lastName = ""
        // Simulate focus loss (old=true → new=false)
        viewModel.onLastNameFocusChanged(oldValue: true, newValue: false)

        XCTAssertNotNil(viewModel.lastNameError)
        XCTAssertEqual(viewModel.nameError, viewModel.lastNameError)
        XCTAssertNil(viewModel.firstNameError)
    }

    func testFocusGainDoesNotValidate() {
        // Arrange: invalid first name but only focus gain
        viewModel.signUpInputModel.firstName = ""

        // Act: focus gained (old=false -> new=true) should NOT validate
        viewModel.onFirstNameFocusChanged(oldValue: false, newValue: true)

        // Assert
        XCTAssertNil(viewModel.firstNameError, "Gaining focus should not trigger validation")
        XCTAssertNil(viewModel.nameError, "No nameError should be shown on focus gain")
    }

    func testResetFirstNameErrorClearsNameErrorWhenOnlyFirstSet() {
        // Arrange: set first name invalid via focus loss
        viewModel.signUpInputModel.firstName = ""
        viewModel.onFirstNameFocusChanged(oldValue: true, newValue: false)
        XCTAssertNotNil(viewModel.nameError, "Precondition: nameError should exist")

        // Act: edit/reset first name error
        viewModel.resetFirstNameError()

        // Assert
        XCTAssertNil(viewModel.firstNameError, "resetFirstNameError should clear firstNameError")
        XCTAssertNil(viewModel.nameError, "nameError should be nil when no other name errors exist")
    }

    func testNameErrorCoalescesToLastNameWhenFirstIsCleared() {
        // Arrange:
        
        // Set last-name error via focus loss

        viewModel.signUpInputModel.lastName = ""
        viewModel.onLastNameFocusChanged(oldValue: true, newValue: false)
        let lastErr = viewModel.lastNameError

        // Then set first-name error via focus loss
        viewModel.signUpInputModel.firstName = ""
        viewModel.onFirstNameFocusChanged(oldValue: true, newValue: false)
        let firstErr = viewModel.firstNameError

        // Sanity: both could be non-nil in current implementation
        XCTAssertNotNil(firstErr)
        XCTAssertNotNil(lastErr)

        // Act: clearing first should reveal last via `nameError` coalescing
        viewModel.resetFirstNameError()

        // Assert
        XCTAssertNil(viewModel.firstNameError, "First name error should be cleared")
        XCTAssertEqual(viewModel.nameError, lastErr, "nameError should now reflect the remaining lastNameError")
    }

    func testNameErrorNilWhenBothNamesValidAfterFocusLoss() {
        viewModel.signUpInputModel.firstName = "Alice"
        viewModel.signUpInputModel.lastName  = "Smith"

        // Focus loss on both fields
        viewModel.onFirstNameFocusChanged(oldValue: true, newValue: false)
        viewModel.onLastNameFocusChanged(oldValue: true, newValue: false)

        XCTAssertNil(viewModel.firstNameError)
        XCTAssertNil(viewModel.lastNameError)
        XCTAssertNil(viewModel.nameError)
    }
}

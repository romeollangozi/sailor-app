//
//  SignUpWithEmailViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

// Subclass that captures navigation instead of hitting the real coordinator.
@MainActor
final class TestableSignUpWithEmailViewModel: SignUpWithEmailViewModel {
    private(set) var didNavigateToDetails = false
    private(set) var capturedEmail: String?
    private(set) var capturedReceiveEmails: Bool?

    override func openSignUpDetailsView(email: String, receiveEmails: Bool) {
        didNavigateToDetails = true
        capturedEmail = email
        capturedReceiveEmails = receiveEmails
    }
}

@MainActor
final class SignUpWithEmailViewModelTests: XCTestCase {

    var repository: SignUpRepositoryMock!
    var tokenUC: MockClientTokenUseCase!
    var validateUC: ValidateEmailUseCaseMock!
    var viewModel: TestableSignUpWithEmailViewModel!

    override func setUp() {
        super.setUp()
        repository = SignUpRepositoryMock()
        tokenUC = MockClientTokenUseCase()
        validateUC = ValidateEmailUseCaseMock(repo: repository)

        viewModel = TestableSignUpWithEmailViewModel(
            clientTokenUseCase: tokenUC,
            validateEmailUseCase: validateUC
        )
    }

    override func tearDown() {
        viewModel = nil
        validateUC = nil
        tokenUC = nil
        repository = nil
        super.tearDown()
    }

    /// Let the async Task inside nextButtonTapped finish.
    private func settle() async {
        await Task.yield()
        try? await Task.sleep(nanoseconds: 80_000_000)
    }

    // MARK: - nextButtonDisabled

    func test_NextButtonDisabled_true_whenEmailInvalid() {
        // Arrange
        viewModel.email = "not-an-email"

        // Act
        let disabled = viewModel.nextButtonDisabled

        // Assert
        XCTAssertTrue(disabled, "Next should be disabled for invalid email")
    }

    func test_NextButtonDisabled_false_whenEmailValid_andNotLoading() {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.isLoading = false

        // Act
        let disabled = viewModel.nextButtonDisabled

        // Assert
        XCTAssertFalse(disabled, "Next should be enabled for valid email when not loading")
    }

    func test_NextButtonDisabled_true_whenLoading() {
        // Arrange
        viewModel.email = "test@example.com"
        viewModel.isLoading = true

        // Act
        let disabled = viewModel.nextButtonDisabled

        // Assert
        XCTAssertTrue(disabled, "Next should be disabled while loading")
    }

    // MARK: - validateEmailField()

    func test_ValidateEmailField_setsError_andReturnsFalse_forInvalidEmail() {
        // Arrange
        viewModel.email = "bad"

        // Act
        let result = viewModel.validateEmailField()

        // Assert
        XCTAssertFalse(result, "Should return false for invalid email")
        XCTAssertNotNil(viewModel.errorMessage, "Should set the validation error when email is invalid")
    }

    func test_ValidateEmailField_clearsError_andReturnsTrue_forValidEmail() {
        // Arrange
        viewModel.email = "ok@domain.com"
        viewModel.errorMessage = "Old error"

        // Act
        let result = viewModel.validateEmailField()

        // Assert
        XCTAssertTrue(result, "Should return true for valid email")
        XCTAssertNil(viewModel.errorMessage, "Should clear the error for a valid email")
    }

    // MARK: - onEmailFieldFocusChanged

    func test_OnEmailFieldFocusChanged_onlyValidatesOnFocusLoss() {
        // Arrange
        viewModel.email = "bad"

        // Act: gaining focus should not validate
        viewModel.onEmailFieldFocusChanged(oldValue: false, newValue: true)
        XCTAssertNil(viewModel.errorMessage, "Gaining focus should not trigger validation")

        // Act: losing focus should validate
        viewModel.onEmailFieldFocusChanged(oldValue: true, newValue: false)

        // Assert
        XCTAssertNotNil(viewModel.errorMessage, "Losing focus should validate and set the error")
    }

    // MARK: - resetErrorMessage()

    func test_ResetErrorMessage_clearsError() {
        // Arrange
        viewModel.errorMessage = "Some error"

        // Act
        viewModel.resetErrorMessage()

        // Assert
        XCTAssertNil(viewModel.errorMessage, "resetErrorMessage should clear the error")
    }

    // MARK: - nextButtonTapped(email:receiveEmails:)

    func test_NextButtonTapped_doesNothing_whenEmailInvalid() async {
        // Arrange: guard should fail
        viewModel.email = "bad"
        viewModel.isLoading = false

        // Act
        viewModel.nextButtonTapped(email: viewModel.email, receiveEmails: true)
        await settle()

        // Assert
        XCTAssertFalse(viewModel.isLoading, "Should not start loading if validation fails")
        XCTAssertFalse(viewModel.didNavigateToDetails, "Should not navigate on invalid email")
        XCTAssertNotNil(viewModel.errorMessage, "Should show validation error")
    }

    func test_NextButtonTapped_tokenNil_doesNotNavigate() async {
        // Arrange: valid email but token is nil
        viewModel.email = "ok@domain.com"
        tokenUC.tokenToReturn = nil

        // Act
        viewModel.nextButtonTapped(email: viewModel.email, receiveEmails: false)
        await settle()

        // Assert
        XCTAssertFalse(viewModel.isLoading, "Loading should stop when token is missing")
        XCTAssertFalse(viewModel.didNavigateToDetails, "Should not navigate without a token")
        XCTAssertNotNil(viewModel.errorMessage, "Error is set for missing token")
    }

    func test_NextButtonTapped_emailExists_setsError_andDoesNotNavigate() async {
        // Arrange: valid email, token present, repo returns "exists"
        viewModel.email = "exists@vv.com"
        tokenUC.tokenToReturn = "token"
        repository.mockValidateEmail = ValidateEmail(isEmailExist: true)

        // Act
        viewModel.nextButtonTapped(email: viewModel.email, receiveEmails: false)
        await settle()

        // Assert
        XCTAssertFalse(viewModel.isLoading, "Loading should end after validation call")
        XCTAssertEqual(viewModel.errorMessage, "This email already exists",
                       "Should show email-exists error from server")
        XCTAssertFalse(viewModel.didNavigateToDetails, "Should not navigate when email already exists")
    }

    func test_NextButtonTapped_emailAvailable_navigates_andClearsError() async {
        // Arrange: valid email, token present, repo returns "does not exist"
        viewModel.email = "new@vv.com"
        tokenUC.tokenToReturn = "token"
        repository.mockValidateEmail = ValidateEmail(isEmailExist: false)

        // Act
        viewModel.nextButtonTapped(email: viewModel.email, receiveEmails: true)
        await settle()

        // Assert
        XCTAssertFalse(viewModel.isLoading, "Loading should end after success")
        XCTAssertNil(viewModel.errorMessage, "Error should be cleared when email is available")
        XCTAssertTrue(viewModel.didNavigateToDetails, "Should navigate to details on success")
        XCTAssertEqual(viewModel.capturedEmail, "new@vv.com", "Should pass the correct email forward")
        XCTAssertEqual(viewModel.capturedReceiveEmails, true, "Should pass the marketing opt-in forward")
    }
}

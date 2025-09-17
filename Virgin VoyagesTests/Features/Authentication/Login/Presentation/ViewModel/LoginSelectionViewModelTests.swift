//
//  LoginSelectionViewModelTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class LoginSelectionViewModelTests: XCTestCase {

	var viewModel: LoginSelectionViewModel!
	var capturedCommands: [NavigationCommandProtocol] = []
    var loginUseCase: MockLoginUseCase!
    
	@MainActor override func setUp() {
		super.setUp()
		capturedCommands = []
        loginUseCase = MockLoginUseCase()
		viewModel = LoginSelectionViewModel(loginUseCase: loginUseCase)

		viewModel.appCoordinator = CommandCapturingCoordinator { [weak self] command in
			self?.capturedCommands.append(command)
		}
	}

	func testSignInWithFacebook_ValidationError_ExecutesCorrectCommand() async throws {
		let user = SocialUser(
			id: "facebook_123",
			firstName: "John",
			lastName: "Doe",
			email: "john@example.com",
			profileImageUrl: nil,
			socialNetworkAPIAccessToken: nil,
			dateOfBirth: nil
		)

        loginUseCase.shouldThrow = true
		try? await viewModel.signInWithFacebook(user: user)

		XCTAssertEqual(capturedCommands.count, 1, "Expected one command to be triggered")

		guard let command = capturedCommands.first as? LandingScreensCoordinator.DismissCurrentSheetAndOpenSignUpCommand else {
			XCTFail("Expected DismissCurrentSheetAndOpenSignUpCommand, got \(String(describing: capturedCommands.first))")
			return
		}

		XCTAssertEqual(command.model.socialMediaId, "facebook_123")
		XCTAssertEqual(command.model.socialMediaType, .facebook)
		XCTAssertEqual(command.model.firstName, "John")
		XCTAssertEqual(command.model.lastName, "Doe")
		XCTAssertEqual(command.model.email, "john@example.com")
	}

	func testSignInWithFacebook_Success_NoCommandExecuted() async throws {
		let user = SocialUser(
			id: "facebook_123",
			firstName: nil,
			lastName: nil,
			email: nil,
			profileImageUrl: nil,
			socialNetworkAPIAccessToken: nil,
			dateOfBirth: nil
		)

        loginUseCase.shouldThrow = false

		try await viewModel.signInWithFacebook(user: user)

		XCTAssertEqual(capturedCommands.count, 0, "No commands should be triggered on successful sign-in")
	}

	func testSignInWithFacebook_NoId_NoCommandExecuted() async throws {
		let user = SocialUser(
			id: nil,
			firstName: nil,
			lastName: nil,
			email: nil,
			profileImageUrl: nil,
			socialNetworkAPIAccessToken: nil,
			dateOfBirth: nil
		)

		try await viewModel.signInWithFacebook(user: user)

		XCTAssertEqual(capturedCommands.count, 0, "No commands should be triggered when user ID is nil")
	}

	// MARK: - isUserCancelled Tests

	@MainActor func testIsUserCancelled_WithFacebookCancellationError_ReturnsTrue() {
		// Given
		let facebookCancellationError = NSError(domain: "Canceled", code: -1, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(facebookCancellationError)

		// Then
		XCTAssertTrue(result, "Should return true for Facebook cancellation error")
	}

	@MainActor func testIsUserCancelled_WithGoogleSignInCancellationError_ReturnsTrue() {
		// Given
		let googleCancellationError = NSError(domain: "com.google.GIDSignIn", code: -5, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(googleCancellationError)

		// Then
		XCTAssertTrue(result, "Should return true for Google Sign-In cancellation error")
	}

	@MainActor func testIsUserCancelled_WithFacebookDomainButWrongCode_ReturnsFalse() {
		// Given
		let facebookErrorWithWrongCode = NSError(domain: "Canceled", code: -2, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(facebookErrorWithWrongCode)

		// Then
		XCTAssertFalse(result, "Should return false for Facebook domain with wrong error code")
	}

	@MainActor func testIsUserCancelled_WithGoogleDomainButWrongCode_ReturnsFalse() {
		// Given
		let googleErrorWithWrongCode = NSError(domain: "com.google.GIDSignIn", code: -3, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(googleErrorWithWrongCode)

		// Then
		XCTAssertFalse(result, "Should return false for Google domain with wrong error code")
	}

	@MainActor func testIsUserCancelled_WithFacebookCodeButWrongDomain_ReturnsFalse() {
		// Given
		let errorWithWrongDomain = NSError(domain: "WrongDomain", code: -1, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(errorWithWrongDomain)

		// Then
		XCTAssertFalse(result, "Should return false for correct Facebook code but wrong domain")
	}

	@MainActor func testIsUserCancelled_WithGoogleCodeButWrongDomain_ReturnsFalse() {
		// Given
		let errorWithWrongDomain = NSError(domain: "WrongDomain", code: -5, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(errorWithWrongDomain)

		// Then
		XCTAssertFalse(result, "Should return false for correct Google code but wrong domain")
	}

	@MainActor func testIsUserCancelled_WithGenericError_ReturnsFalse() {
		// Given
		let genericError = NSError(domain: "GenericError", code: 500, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(genericError)

		// Then
		XCTAssertFalse(result, "Should return false for generic error")
	}

	@MainActor func testIsUserCancelled_WithNonNSError_ReturnsFalse() {
		// Given
		struct CustomError: Error {}
		let customError = CustomError()

		// When
		let result = viewModel.isUserCancelledError(customError)

		// Then
		XCTAssertFalse(result, "Should return false for non-NSError types")
	}

	@MainActor func testIsUserCancelled_WithNetworkError_ReturnsFalse() {
		// Given
		let networkError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(networkError)

		// Then
		XCTAssertFalse(result, "Should return false for network errors")
	}

	@MainActor func testIsUserCancelled_WithEmptyDomain_ReturnsFalse() {
		// Given
		let emptyDomainError = NSError(domain: "", code: -1, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(emptyDomainError)

		// Then
		XCTAssertFalse(result, "Should return false for error with empty domain")
	}

	@MainActor func testIsUserCancelled_WithZeroCode_ReturnsFalse() {
		// Given
		let zeroCodeError = NSError(domain: "Canceled", code: 0, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(zeroCodeError)

		// Then
		XCTAssertFalse(result, "Should return false for error with zero code")
	}

	@MainActor func testIsUserCancelled_WithPositiveCode_ReturnsFalse() {
		// Given
		let positiveCodeError = NSError(domain: "Canceled", code: 1, userInfo: nil)

		// When
		let result = viewModel.isUserCancelledError(positiveCodeError)

		// Then
		XCTAssertFalse(result, "Should return false for error with positive code")
	}
}

// MARK: - CommandCapturingCoordinator

final class CommandCapturingCoordinator: CoordinatorProtocol {
    
    func calculateCurrentScreenFlow() {
        
    }
    
	var offlineModeLandingScreenCoordinator = OfflineModeHomeLandingScreenCoordinator()
	var landingScreenCoordinator = LandingScreensCoordinator()
	var discoverCoordinator = DiscoverCoordinator()
	var homeTabBarCoordinator = HomeTabBarCoordinator(selectedTab: .dashboard)
    var authenticationService: AuthenticationServiceProtocol = MockAuthenticationService()
    var currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()
    var currentFlow: ApplicationFlow = .initialLoading


	private let onCommand: (NavigationCommandProtocol) -> Void

	init(onCommand: @escaping (NavigationCommandProtocol) -> Void) {
		self.onCommand = onCommand
	}

	func executeCommand(_ command: NavigationCommandProtocol) {
		onCommand(command)
	}
}


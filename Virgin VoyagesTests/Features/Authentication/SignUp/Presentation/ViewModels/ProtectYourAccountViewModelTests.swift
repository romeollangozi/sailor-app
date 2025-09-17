//
//  ProtectYourAccountViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 2.9.24.
//

import XCTest
@testable import Virgin_Voyages

final class ProtectYourAccountViewModelTests: XCTestCase {

	var viewModel: ProtectYourAccountViewModel!
	var signUpInputModel: SignUpInputModel!
	var mockCoordinator: MockCoordinator!

	override func setUp() {
		super.setUp()
		mockCoordinator = MockCoordinator()
		signUpInputModel = SignUpInputModel(password: "")
		viewModel = ProtectYourAccountViewModel(signUpInputModel: signUpInputModel)
	}

	override func tearDown() {
		viewModel = nil
		signUpInputModel = nil
		mockCoordinator = nil
		super.tearDown()
	}

	func testInitialValidationState() {
		// Test initial validation state
		XCTAssertEqual(viewModel.validations, [false, false, false, false], "Initial validation state should be all false")
		XCTAssertTrue(viewModel.nextButtonDisabled, "Next button should be disabled initially")
	}

	func testValidPasswordLength() {
		viewModel.password = "Password1!"
		XCTAssertTrue(viewModel.validations[0], "Password should satisfy the length criterion")
	}

	func testValidPasswordUppercase() {
		viewModel.password = "password1!"
		XCTAssertFalse(viewModel.validations[1], "Password without uppercase letter should fail the uppercase criterion")

		viewModel.password = "Password1!"
		XCTAssertTrue(viewModel.validations[1], "Password with uppercase letter should pass the uppercase criterion")
	}

	func testValidPasswordNumber() {
		viewModel.password = "Password!"
		XCTAssertFalse(viewModel.validations[2], "Password without a number should fail the number criterion")

		viewModel.password = "Password1!"
		XCTAssertTrue(viewModel.validations[2], "Password with a number should pass the number criterion")
	}

	func testValidPasswordSymbol() {
		viewModel.password = "Password1"
		XCTAssertFalse(viewModel.validations[3], "Password without a symbol should fail the symbol criterion")

		viewModel.password = "Password1!"
		XCTAssertTrue(viewModel.validations[3], "Password with a symbol should pass the symbol criterion")
	}

	func testValidPasswordAllCriteria() {
		viewModel.password = "Password1!"
		XCTAssertEqual(viewModel.validations, [true, true, true, true], "Password meeting all criteria should validate successfully")
		XCTAssertFalse(viewModel.nextButtonDisabled, "Next button should be enabled when password meets all criteria")
	}

	func testInvalidPasswordDisablesNextButton() {
		viewModel.password = "Pass!"
		XCTAssertTrue(viewModel.nextButtonDisabled, "Next button should be disabled when password doesn't meet all criteria")
	}

	func testNavigateToProfileImageView_ExecutesCorrectCommand() {
		var executedCommands: [Any] = []
		let trackingCoordinator = TrackingCoordinator { command in
			executedCommands.append(command)
		}

		viewModel = ProtectYourAccountViewModel(appCoordinator: trackingCoordinator, signUpInputModel: signUpInputModel)

		viewModel.navigateToProfileImageView()
		XCTAssertEqual(executedCommands.count, 1, "Should execute exactly one command")

		guard let executedCommand = executedCommands.first as? SignupCoordinator.OpenStrikePoseViewCommand else {
			XCTFail("Expected OpenStrikePoseViewCommand to be executed")
			return
		}
	}
}


class TrackingCoordinator: CoordinatorProtocol {
    
    var currentFlow: ApplicationFlow = .initialLoading
    
    func calculateCurrentScreenFlow() { }
    
	var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator = .init()
	var homeTabBarCoordinator: HomeTabBarCoordinator = HomeTabBarCoordinator(selectedTab: .dashboard)
	var landingScreenCoordinator: LandingScreensCoordinator = .init()
	var discoverCoordinator: DiscoverCoordinator = .init()
    var authenticationService: AuthenticationServiceProtocol = MockAuthenticationService()
    var currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()

	private let commandHandler: (any NavigationCommandProtocol) -> Void

	init(commandHandler: @escaping (any NavigationCommandProtocol) -> Void) {
		self.commandHandler = commandHandler
	}

	func executeCommand(_ command: any NavigationCommandProtocol) {
		commandHandler(command)
	}
}

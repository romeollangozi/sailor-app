//
//  AddOnsListScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.6.25.
//


import XCTest
@testable import Virgin_Voyages

@MainActor
class AddOnsListScreenViewModelTests: XCTestCase {

	var sut: AddOnsListScreenViewModel!
	var mockCoordinator: MockNavigationCoordinator!
	var mockAddOnsUseCase: MockGetAddOnsUseCase!

	override func setUp() {
		super.setUp()
		mockCoordinator = MockNavigationCoordinator()
		mockAddOnsUseCase = MockGetAddOnsUseCase()

		sut = AddOnsListScreenViewModel(
			addOnsUseCase: mockAddOnsUseCase,
			addons: []
		)
		sut.navigationCoordinator = mockCoordinator
	}

	override func tearDown() {
		sut = nil
		mockCoordinator = nil
		mockAddOnsUseCase = nil
		super.tearDown()
	}

	func testGoToPurchasedAddOns_ExecutesCorrectCommand() {
		// When
		sut.onViewAddOnsTapped()

		// Then
		XCTAssertEqual(mockCoordinator.executeCommandCallCount, 1)
		XCTAssertTrue(mockCoordinator.lastExecutedCommand is HomeTabBarCoordinator.OpenMeAddonsScreenCommand)
	}
}

// MARK: - Mock Classes
class MockNavigationCoordinator: CoordinatorProtocol {
    
	var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator = .init()
	var homeTabBarCoordinator: HomeTabBarCoordinator = HomeTabBarCoordinator(selectedTab: .dashboard)
	var landingScreenCoordinator: LandingScreensCoordinator = .init()
	var discoverCoordinator: DiscoverCoordinator = .init()
    var authenticationService: AuthenticationServiceProtocol = MockAuthenticationService()
    var currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()

    var currentFlow: ApplicationFlow = .initialLoading
    var executeCommandCallCount = 0
	var lastExecutedCommand: NavigationCommandProtocol?

	func executeCommand(_ command: any NavigationCommandProtocol) {
		executeCommandCallCount += 1
		lastExecutedCommand = command
	}
   
    func calculateCurrentScreenFlow() { }

}

class MockGetAddOnsUseCase: GetAddOnsUseCase {
	func getAddOns() async -> Result<AddOnDetails, Error> {
		return .success(AddOnDetails(addOns: [AddOn.sample]))
	}
}


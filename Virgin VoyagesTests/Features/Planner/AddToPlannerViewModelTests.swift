//
//  AddToPlannerViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 4.9.25.
//

import XCTest
@testable import Virgin_Voyages

final class AddToPlannerViewModelTests: XCTestCase {

    private var viewModel: AddToPlannerViewModel!
    private var mockCoordinator: MockAppCoordinator!

    @MainActor
    override func setUp() {
        super.setUp()
        mockCoordinator = MockAppCoordinator()
        viewModel = AddToPlannerViewModel(navigationCoordinator: mockCoordinator)
    }

    @MainActor func test_actions_are_initialized_correctly() {
        let titles = viewModel.actions.map(\.title)

        XCTAssertEqual(titles.count, 3)
        XCTAssertEqual(titles, ["Dining Reservation", "Spa Treatments", "Shore Excursion"])
    }

    @MainActor func test_onDismiss_executesDismissCommand() {
        viewModel.onDismiss()

        guard let command = mockCoordinator.lastExecutedCommand as? HomeTabBarCoordinator.DismissFullScreenOverlayCommand else {
            return XCTFail("Expected DismissFullScreenOverlayCommand to be executed")
        }

        XCTAssertEqual(command.pathToDismiss, .addToPlanner)
    }
}

final class MockAppCoordinator: AppCoordinator {
    private(set) var lastExecutedCommand: NavigationCommandProtocol?

    override func executeCommand(_ command: NavigationCommandProtocol) {
        lastExecutedCommand = command
    }
}

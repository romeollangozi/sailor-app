//
//  ConfirmOrderChampagneViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 8.7.25.
//

//
//  ConfirmOrderChampagneViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 8.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class ConfirmOrderChampagneViewModelTests: XCTestCase {

    // MARK: - Mocks

    final class MockShakeForChampagneCoordinator: ShakeForChampagneCoordinator {
        override var fullScreenRouter: ShakeForChampagneFullScreenOverlayRoute? {
            didSet {
                if fullScreenRouter == nil {
                    didClearFullScreen = true
                }
            }
        }

        var didClearFullScreen = false
    }

    final class MockNavigationCoordinator: CoordinatorProtocol {
        var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator = .init()
        var homeTabBarCoordinator: HomeTabBarCoordinator = .init(selectedTab: .dashboard)
        var landingScreenCoordinator: LandingScreensCoordinator = .init()
        var discoverCoordinator: DiscoverCoordinator = .init()
        var authenticationService: AuthenticationServiceProtocol = MockAuthenticationService()
        var currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()

        var currentFlow: ApplicationFlow = .initialLoading

        var didExecuteDismissCommand = false

        func executeCommand(_ command: any NavigationCommandProtocol) {
            if command is HomeTabBarCoordinator.DismissFullScreenOverlayCommand {
                didExecuteDismissCommand = true
            }
        }
        
        func calculateCurrentScreenFlow() { }

    }

    // MARK: - Helpers

    func makeViewModel(state: ShakeForChampagne.Status) -> (ConfirmOrderChampagneViewModel, MockShakeForChampagneCoordinator, MockNavigationCoordinator) {
        let champagne = ShakeForChampagne(
            title: "Title",
            description: "Desc",
            champagne: .init(name: "Champagne", price: 42, currency: "USD", minQuantity: 1, maxQuantity: 3),
            champagneState: .init(state: state, message: "", actionText: ""),
            taxExplanationText: "Tax",
            confirmationTitle: "Confirm Title",
            confirmationDescription: "Standard Desc",
            confirmationDeliveryDescription: "Has been delivered",
            confirmationHeaderText: "Header",
            quote: .init(author: "Author", text: "Quote"),
            cancellation: .init(title: "", description: "", cancelButton: "Cancel", continueButton: "", successMessage: "", successHeader: "", successActionText: ""),
            cancellationActionText: "Cancel Order",
            permission: .init(description: "")
        )

        let mockCoordinator = MockShakeForChampagneCoordinator()
        let mockNav = MockNavigationCoordinator()

        let vm = ConfirmOrderChampagneViewModel(coordinator: mockCoordinator, shakeForChampagne: champagne, onCloseAction: nil)
        vm.navigationCoordinator = mockNav
        return (vm, mockCoordinator, mockNav)
    }

    // MARK: - Testsgit 

    func test_onAppear_setsScreenStateToContent() {
        let (vm, _, _) = makeViewModel(state: .available)
        vm.onAppear()
        XCTAssertEqual(vm.screenState, .content)
    }

    func test_onRefresh_setsScreenStateToContent() {
        let (vm, _, _) = makeViewModel(state: .available)
        vm.onRefresh()
        XCTAssertEqual(vm.screenState, .content)
    }

    func test_init_withDeliveredState_setsCorrectValuesAndHidesCancelButton() {
        let (vm, _, _) = makeViewModel(state: .orderDelivered)

        XCTAssertEqual(vm.shakeForChampagne.confirmationDeliveryDescription, "Has been delivered")
        XCTAssertFalse(vm.shouldShowCancelButton)
    }

    func test_init_withAvailableState_setsCorrectValuesAndShowsCancelButton() {
        let (vm, _, _) = makeViewModel(state: .available)

        XCTAssertEqual(vm.shakeForChampagne.confirmationHeaderText, "Header")
        XCTAssertEqual(vm.shakeForChampagne.confirmationTitle, "Confirm Title")
        XCTAssertEqual(vm.shakeForChampagne.quote.text, "Quote")
        XCTAssertEqual(vm.shakeForChampagne.quote.author, "Author")
        XCTAssertEqual(vm.shakeForChampagne.cancellationActionText, "Cancel Order")
        XCTAssertEqual(vm.shakeForChampagne.confirmationDescription, "Standard Desc")
        XCTAssertTrue(vm.shouldShowCancelButton)
    }
}

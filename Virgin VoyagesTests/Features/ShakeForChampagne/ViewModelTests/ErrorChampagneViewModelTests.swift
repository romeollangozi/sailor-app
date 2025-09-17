//
//  ErrorChampagneViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 7.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class ErrorChampagneViewModelTests: XCTestCase {

    // MARK: - Mock Coordinator

    final class MockShakeForChampagneCoordinator: ShakeForChampagneCoordinator {
        override var fullScreenRouter: ShakeForChampagneFullScreenOverlayRoute? {
            didSet {
                if fullScreenRouter == nil {
                    dismissed = true
                }
            }
        }

        var dismissed = false
        var navigatedToBarsAndClubs = false
    }
    
    final class MockNavigationCoordinator: CoordinatorProtocol {
        var offlineModeLandingScreenCoordinator: OfflineModeHomeLandingScreenCoordinator = .init()
        var homeTabBarCoordinator: HomeTabBarCoordinator = HomeTabBarCoordinator(selectedTab: .dashboard)
        var landingScreenCoordinator: LandingScreensCoordinator = .init()
        var discoverCoordinator: DiscoverCoordinator = .init()
        var authenticationService: AuthenticationServiceProtocol = MockAuthenticationService()
        var currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()

        var currentFlow: ApplicationFlow = .initialLoading
        var didExecuteDismissCommand = false
        var didNavigateToShipSpace = false
        var capturedShipSpaceCode: String?

        func executeCommand(_ command: any NavigationCommandProtocol) {
            switch command {
            case is HomeTabBarCoordinator.DismissFullScreenOverlayCommand:
                didExecuteDismissCommand = true
            case let openCommand as ShakeForChampagneCoordinator.OpenShipSpaceScreenCommand:
                didNavigateToShipSpace = true
                capturedShipSpaceCode = openCommand.shipSpaceCode
            default:
                break
            }
        }
        
        func calculateCurrentScreenFlow() { }

    }
    // MARK: - Helpers

    func makeViewModel(state: ShakeForChampagne.Status) -> (ErrorChampagneViewModel, MockShakeForChampagneCoordinator, MockNavigationCoordinator) {
        let champagne = ShakeForChampagne(
            title: "",
            description: "",
            champagne: .init(name: "", price: 0, currency: "", minQuantity: 0, maxQuantity: 0),
            champagneState: .init(state: state, message: "Test Message", actionText: "Test Action"),
            taxExplanationText: "",
            confirmationTitle: "",
            confirmationDescription: "",
            confirmationDeliveryDescription: "",
            confirmationHeaderText: "",
            quote: .init(author: "", text: ""),
            cancellation: .init(title: "", description: "", cancelButton: "", continueButton: "", successMessage: "", successHeader: "", successActionText: ""),
            cancellationActionText: "",
            permission: .init(description: "")
        )

        let mockCoordinator = MockShakeForChampagneCoordinator()
        let mockNav = MockNavigationCoordinator()
        let vm = ErrorChampagneViewModel(
            coordinator: mockCoordinator,
            shakeForChampagne: champagne,
            onCloseAction: nil
        )
        vm.navigationCoordinator = mockNav
        return (vm, mockCoordinator, mockNav)
    }

    // MARK: - Tests

    func test_onAppear_setsScreenStateToContent() {
        let (vm, _, _) = makeViewModel(state: .closed)
        vm.onAppear()
        XCTAssertEqual(vm.screenState, .content)
    }

    func test_onRefresh_setsScreenStateToContent() {
        let (vm, _, _) = makeViewModel(state: .available)
        vm.onRefresh()
        XCTAssertEqual(vm.screenState, .content)
    }

    func test_onButtonTap_withClosedState_triggersDismissAndNavigation() {
        let (vm, _, nav) = makeViewModel(state: .closed)

        vm.onButtonTap()
        XCTAssertTrue(nav.didNavigateToShipSpace)
        XCTAssertEqual(nav.capturedShipSpaceCode, "Bars---Clubs")
    }

    func test_onButtonTap_withOtherState_justDismisses() {
        let (vm, _, nav) = makeViewModel(state: .unavailable)

        vm.onButtonTap()
        XCTAssertTrue(nav.didExecuteDismissCommand)
    }

    func test_onClose_executesDismiss() {
        let (vm, _, nav) = makeViewModel(state: .restricted)

        vm.onClose()
        XCTAssertTrue(nav.didExecuteDismissCommand)
    }

    func test_init_assignsCorrectTexts() {
        let (vm, _, _) = makeViewModel(state: .available)

        XCTAssertEqual(vm.headerText, "HEY SAILOR")
        XCTAssertEqual(vm.messageText, "Test Message")
        XCTAssertEqual(vm.buttonText, "Test Action")
    }
}

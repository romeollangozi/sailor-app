//
//  ProfileReservationCoreErrorViewModelTests.swift
//  Virgin Voyages
//
//  Created by TX on 29.8.25.
//

import Foundation
import XCTest
@testable import Virgin_Voyages

@MainActor
final class ProfileReservationCoreErrorViewModelTests: XCTestCase {

    // SUT & dependencies
    var viewModel: ProfileReservationCoreErrorViewModel!
    var mockLocalizationManager: MockLocalizationManager!
    var mockAuthenticationService: MockAuthenticationService!
    var mockLogoutUseCase: MockLogoutUserUseCase!

    override func setUp() {
        super.setUp()
        mockLocalizationManager = MockLocalizationManager()
        mockAuthenticationService = MockAuthenticationService()
        mockLogoutUseCase = MockLogoutUserUseCase()

        viewModel = ProfileReservationCoreErrorViewModel(
            localizationManager: mockLocalizationManager,
            authenticationService: mockAuthenticationService,
            logoutUserUseCase: mockLogoutUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        mockLocalizationManager = nil
        mockAuthenticationService = nil
        mockLogoutUseCase = nil
        super.tearDown()
    }

    // MARK: - Read-only state (no localization assertions)

    func testInitialState_allowsOneReloadAttempt() async {
        // Given a fresh VM (reloadAttemptCount == 0, maxAttemptCount == 1)
        XCTAssertTrue(viewModel.shouldAllowReload, "Fresh VM should allow one reload attempt.")
        XCTAssertFalse(viewModel.primaryButtonIsLoading, "Fresh VM should not be loading.")
    }

    // MARK: - Primary button (reload path)

    func testPrimaryTap_whenAllowReload_callsReload_and_resetsLoading_onSuccess() async {
        // Given: auth reload succeeds
        mockAuthenticationService.shouldThrowError = false

        // Precondition
        XCTAssertFalse(viewModel.primaryButtonIsLoading)

        // When (immediate effects)
        viewModel.onPrimaryButtonTapped()
        XCTAssertTrue(viewModel.primaryButtonIsLoading, "Primary button should reflect loading when reload kicks off.")

        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms delay

        // Then
        
        XCTAssertNil(mockAuthenticationService.reloadedReservationNumber, "VM passes `nil` reservationNumber.")
        XCTAssertFalse(viewModel.primaryButtonIsLoading, "Loading should reset to false after a successful reload.")
    }

    func testPrimaryTap_whenAllowReload_onFailure_incrementsAttemptCount_and_resetsLoading() async {
        // Given: auth reload fails
        mockAuthenticationService.shouldThrowError = true
        mockAuthenticationService.errorToThrow = VVDomainError.genericError

        // When (immediate effects)
        viewModel.onPrimaryButtonTapped()

        XCTAssertTrue(viewModel.primaryButtonIsLoading, "Loading should be true right after tap (before async completes).")

        // Then
        try? await Task.sleep(nanoseconds: 20_000_000) // 10ms delay

        XCTAssertFalse(viewModel.primaryButtonIsLoading, "After failure, VM resets loading to false.")
        XCTAssertFalse(viewModel.shouldAllowReload, "After one failure (max 1), reload should be disallowed.")
    }

    // MARK: - Primary button (logout path)

    func testPrimaryTap_whenReloadDisallowed_triggersLogout() async {
        // Given: fail once to consume the only allowed attempt
        mockAuthenticationService.shouldThrowError = true
        viewModel.onPrimaryButtonTapped()
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms delay

        XCTAssertFalse(viewModel.shouldAllowReload, "After failure, further reloads are disallowed.")

        // When: pressing primary again should call logout use case
        viewModel.onPrimaryButtonTapped()
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms delay

        // Then
        XCTAssertTrue(mockLogoutUseCase.isExecuted, "When reload is disallowed, primary tap should logout.")
    }

    // MARK: - Nice-to-have: smoke test for constants (no localization)

    func testLayoutAndActions_areStable() {
        XCTAssertEqual(viewModel.imageName, "exception_server_error")
        XCTAssertEqual(viewModel.exceptionLayout, .withLinkButton)
        XCTAssertEqual(viewModel.primaryButtonAction, .primaryButtonAction)
        XCTAssertEqual(viewModel.secondaryButtonAction, .secondaryButtonAction)
    }
}

//
//  AuthenticationServiceTests.swift
//  Virgin Voyages
//
//  Created by TX on 27.8.25.
//

import XCTest
import UIKit
@testable import Virgin_Voyages

final class AuthenticationServiceTests: XCTestCase {

    private var sut: AuthenticationService!
    private var tokenRepo: MockTokenRepository!
    private var sailorMgr: MockCurrentSailorManager!
    private var reservationsRepo: MockReservationsRepository!
    private var eventSpy: MockAuthEventService!

    override func setUp() async throws {
        try await super.setUp()

        // Use the singleton and inject replaceable dependencies.
        sut = AuthenticationService.shared

        tokenRepo = MockTokenRepository()
        sailorMgr = MockCurrentSailorManager()
        reservationsRepo = MockReservationsRepository()
        eventSpy = MockAuthEventService()

        // Inject our doubles
        sut.tokenRepository = tokenRepo
        sut.currentSailorManager = sailorMgr
        sut.reservationRepository = reservationsRepo
        sut.authenticationEventNotificationService = eventSpy

        // Reset state between tests
        sut.currentAccount = nil
        sut.userProfile = nil
        sut.reservation = nil
        sut.isFetchingReservation = false
        sut.isSwitchingReservation = false
        eventSpy.reset()
    }

    override func tearDown() async throws {
        sut = nil
        tokenRepo = nil
        sailorMgr = nil
        reservationsRepo = nil
        eventSpy = nil
        try await super.tearDown()
    }

    // MARK: - isLoggedIn / userHasReservation

    /// Ensures isLoggedIn() returns false when there's no current account.
    func test_isLoggedIn_whenNoToken_returnsFalse() {
        sut.currentAccount = nil
        XCTAssertFalse(sut.isLoggedIn())
    }

    /// Ensures isLoggedIn() returns true when a token is present.
    func test_isLoggedIn_whenTokenPresent_returnsTrue() {
        sut.currentAccount = TestData.dummyToken
        XCTAssertTrue(sut.isLoggedIn())
    }

    /// Ensures userHasReservation() is false when no reservation is selected.
    func test_userHasReservation_whenReservationNil_returnsFalse() {
        sut.reservation = nil
        XCTAssertFalse(sut.userHasReservation())
    }

    // MARK: - signOut()

    /// signOut should clear auth-related state and delete the stored token.
    /// We don't assert on CurrentSailorManager since the mock's deleteCurrentSailor() is a no-op.
    func test_signOut_clearsState_and_deletesToken() async {
        // given
        sut.currentAccount = TestData.dummyToken
        sut.userProfile = TestData.dummyUserProfile

        // when
        await sut.signOut()

        // then
        XCTAssertTrue(tokenRepo.didDelete, "Expected token repo to delete token")
        XCTAssertNil(sut.currentAccount, "Expected current account cleared")
        XCTAssertNil(sut.userProfile, "Expected user profile cleared")
        XCTAssertNil(sut.reservation, "Expected reservation cleared")
    }

    // MARK: - reloadReservation()

    /// reloadReservation should publish screen-flow recalculation at start and at finish,
    /// even if the underlying network operations fail.
//    func test_reloadReservation_publishes_startAndFinish_events_evenOnFailure() async {
//        // Make currentUser() not throw
//        sut.currentAccount = TestData.dummyToken
//
//        try? await self.sut.reloadReservation(reservationNumber: nil)
//
//        let recalcs = eventSpy.published.filter { $0 == .shouldRecalculateApplicationScreenFlow }
//        XCTAssertEqual(recalcs.count, 2, "Expected start & finish recalculation events")
//        XCTAssertFalse(sut.isFetchingReservation, "Fetching flag should be false after completion")
//    }

    // MARK: - finishLogin

    /// finishLogin should store the token and (via reloadReservation) fire start/finish events.
    func test_finishLogin_storesToken_and_triggersReloadReservationEvents() async {
        try? await self.sut.finishLogin(account: TestData.dummyToken)
        XCTAssertTrue(tokenRepo.didStore, "Expected token stored")
        let recalcs = eventSpy.published.filter { $0 == .shouldRecalculateApplicationScreenFlow }
        XCTAssertEqual(recalcs.count, 2, "Expected reloadReservation start & finish events inside finishLogin")
    }


    // MARK: - Integration with MockCurrentSailorManager

    /// If reloadReservation proceeds far enough, AuthenticationService asks the manager
    /// to create a CurrentSailor from a SailorProfileV2. Because the repo inside
    /// reloadReservation isn't injectable, we can't force success here, but we can still
    /// assert manager starts with sensible defaults and that setCurrentSailor(...)
    /// can be called/observed in other flows.
    func test_mockCurrentSailorManager_defaults_and_setCurrentSailor_flag() {
        // defaults
        XCTAssertFalse(sailorMgr.setCurrentSailorCalled, "Should not be set yet")
        XCTAssertNotNil(sailorMgr.getCurrentSailor(), "Your mock returns last or empty by default")

        // when
        let someone = CurrentSailor.empty()
        _ = sailorMgr.setCurrentSailor(currentSailor: someone)

        // then
        XCTAssertTrue(sailorMgr.setCurrentSailorCalled, "Expected setCurrentSailor to be recorded")
        XCTAssertEqual(sailorMgr.getCurrentSailor()?.reservationNumber, someone.reservationNumber)
    }

    // MARK: - NOTE on preloadReservation
    // preloadReservation() is private and runs in the service initializer.
}

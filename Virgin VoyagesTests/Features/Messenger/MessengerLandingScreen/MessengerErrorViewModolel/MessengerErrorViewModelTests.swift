//
//  MessengerErrorViewModelTests.swift
//  Virgin Voyages
//
//  Created by TX on 21.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class MessengerErrorViewModelTests: XCTestCase {

    // Verifies initial state and shouldShowRetryButton for .retryAvailable
    func test_initialState_retryAvailable() {
        let vm = MessengerErrorViewModel()
        XCTAssertEqual(vm.state, .retryAvailable)
        XCTAssertTrue(vm.shouldShowRetryButton)
        XCTAssertEqual(vm.attempts, 0)
        XCTAssertEqual(vm.maxAttempts, 3)
    }

    // Verifies registerAttempt() increments attempts and flips state to .retryUnavailable when reaching maxAttempts
    func test_registerAttempt_reachesMax_disablesRetry() {
        let vm = MessengerErrorViewModel()
        vm.registerAttempt()
        vm.registerAttempt()
        XCTAssertEqual(vm.attempts, 2)
        XCTAssertEqual(vm.state, .retryAvailable)

        vm.registerAttempt()
        XCTAssertEqual(vm.attempts, 3)
        XCTAssertEqual(vm.state, .retryUnavailable)
        XCTAssertFalse(vm.shouldShowRetryButton)
    }

    // Verifies reset() clears attempts and restores .retryAvailable
    func test_reset_restoresRetry() {
        let vm = MessengerErrorViewModel()
        (0..<vm.maxAttempts).forEach { _ in vm.registerAttempt() }
        XCTAssertEqual(vm.state, .retryUnavailable)

        vm.reset()
        XCTAssertEqual(vm.attempts, 0)
        XCTAssertEqual(vm.state, .retryAvailable)
        XCTAssertTrue(vm.shouldShowRetryButton)
    }
}

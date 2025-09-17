//
//  CountdownTimerTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 10.4.25.
//

import XCTest
import Combine
@testable import Virgin_Voyages

final class CountdownTimerTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testCountdownWithinThreshold_ShowsCorrectText() {
        let timer = CountdownTimer()
        let expectation = XCTestExpectation(description: "Countdown updates text")

        timer.$countdownText
            .dropFirst()
            .sink { text in
                XCTAssertEqual(text, "2h 30m")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        timer.startCountdown(secondsLeft: 2 * 3600 + 30 * 60)

        wait(for: [expectation], timeout: 1.0)
    }

    func testCountdownWithDays_ShowsCorrectFormat() {
        let timer = CountdownTimer()
        let expectation = XCTestExpectation(description: "Countdown with days")

        timer.$countdownText
            .dropFirst()
            .sink { text in
                XCTAssertEqual(text, "2d 1h 1m")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        timer.startCountdown(secondsLeft: 2 * 86400 + 1 * 3600 + 60)

        wait(for: [expectation], timeout: 1.0)
    }

    func testCountdownInPast_SetsEmptyText() {
        let timer = CountdownTimer()
        timer.startCountdown(secondsLeft: -100)

        XCTAssertEqual(timer.countdownText, "")
    }

    func testCountdownTooFarInFuture_SetsEmptyText() {
        let timer = CountdownTimer()
        timer.startCountdown(secondsLeft: 90000) // > 86400

        XCTAssertEqual(timer.countdownText, "")
    }

    func testCountdownZeroInterval_SetsEmptyText() {
        let timer = CountdownTimer()
        timer.startCountdown(secondsLeft: 0)

        XCTAssertEqual(timer.countdownText, "")
    }

    func testInvalidate_ClearsTimer() {
        let timer = CountdownTimer()
        timer.startCountdown(secondsLeft: 60)
        timer.invalidate()

        XCTAssertNoThrow(timer.invalidate())
    }
}

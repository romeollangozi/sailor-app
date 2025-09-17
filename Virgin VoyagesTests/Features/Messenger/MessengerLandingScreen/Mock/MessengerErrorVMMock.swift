//
//  MessengerErrorVMMock.swift
//  Virgin Voyages
//
//  Created by TX on 21.8.25.
//

import Foundation
@testable import Virgin_Voyages
@testable import VVUIKit

final class MessengerErrorVMMock: MessengerErrorRetryViewModelProtocol {
    var state: MessengerErrorState = .retryAvailable
    var attempts: Int = 0
    var maxAttempts: Int = 3
    private(set) var registerAttemptCount = 0
    private(set) var resetCalled = false

    var shouldShowRetryButton: Bool { state == .retryAvailable }

    func registerAttempt() {
        registerAttemptCount += 1
        attempts += 1
        if attempts >= maxAttempts {
            state = .retryUnavailable
        }
    }

    func reset() {
        resetCalled = true
        attempts = 0
        state = .retryAvailable
    }
}

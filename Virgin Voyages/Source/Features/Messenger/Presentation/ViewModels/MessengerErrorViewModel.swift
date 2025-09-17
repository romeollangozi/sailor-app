//
//  MessengerErrorViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 21.8.25.
//

import VVUIKit

@Observable
final class MessengerErrorViewModel: MessengerErrorRetryViewModelProtocol {

    var state: MessengerErrorState
    var attempts: Int = 0
    var maxAttempts: Int = 3

    init(initialState: MessengerErrorState = .retryAvailable) {
        self.state = initialState
    }

    /// User taps "Try again"
    func registerAttempt() {
        attempts += 1
        print("attempts :  \(attempts)")
        if attempts >= maxAttempts {
            state = .retryUnavailable
        }
    }

    /// Call on successful reload resets state
    func reset() {
        attempts = 0
        state = .retryAvailable
    }
    
    var shouldShowRetryButton: Bool {
        state == .retryAvailable
    }
}

//
//  MessengerRetryViewModelProtocol.swift
//  Virgin Voyages
//
//  Created by TX on 20.8.25.
//

public protocol MessengerErrorRetryViewModelProtocol {
    var state: MessengerErrorState { get }
    var attempts: Int { get }
    var maxAttempts: Int { get }
    var shouldShowRetryButton: Bool { get }
    func registerAttempt()
    func reset()
}


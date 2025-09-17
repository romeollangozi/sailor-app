//
//  GetChatThreadsUseCaseMock.swift
//  Virgin Voyages
//
//  Created by TX on 21.8.25.
//


import Foundation
@testable import Virgin_Voyages

// MARK: - Threads

final class GetChatThreadsUseCaseMock: GetChatThreadsUseCaseProtocol {
    var result: [ChatThread]?
    init(result: [ChatThread]?) { self.result = result }
    func execute() async throws -> [ChatThread] {
        if let result { return result }
        throw VVMessengerError.failedToFetchMessages
    }
}

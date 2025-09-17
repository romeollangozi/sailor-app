//
//  MockChatThreadsRepository.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockChatThreadsRepository: ChatThreadsRepositoryProtocol {
    
    var mockThreads: [ChatThread] = []
    var shouldThrowError: Bool = false
    var errorToThrow: Error = VVDomainError.genericError
    
    var shouldThrow = false
    var expectedQueueId: String?
    var lastMarkedMessageIDs: [Int] = []

    func getChatThreads(voyageNumber: String, sailorType: Virgin_Voyages.SailorType, reservationGuesID: String) async throws -> [Virgin_Voyages.ChatThread] {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockThreads
    }
    
    func markChatThreadMessagesAsRead(messageIDs: [Int], queueID: String) async throws -> Bool {
        lastMarkedMessageIDs = messageIDs
        expectedQueueId = queueID

        if shouldThrow {
            throw VVDomainError.genericError
        }

        return true
    }

}

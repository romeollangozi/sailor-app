//
//  MockChatThreadMessagesRepository.swift
//  Virgin Voyages
//
//  Created by TX on 19.5.25.
//

import XCTest
@testable import Virgin_Voyages

class MockChatThreadMessagesRepository: ChatThreadMessagesRepositoryProtocol {
    
    
    var shouldThrow = false
    var expectedQueueId: String = ""
    var lastMarkedMessageIDs: [Int] = []

    func fetchChatThreadMessages(threadId: Int, voyageNumber: String, sailorId: String, pageSize: Int, anchor: Int?, type: String) async throws -> ChatMessages? {
        return nil
    }

    func markChatThreadMessagesAsRead(messageIDs: [Int], queueID: String) async throws -> Bool {
        lastMarkedMessageIDs = messageIDs
        expectedQueueId = queueID

        if shouldThrow {
            throw VVDomainError.genericError
        }

        return true
    }
    
    func fetchChatThreadMessages(threadId: String, voyageNumber: String, sailorId: String, pageSize: Int, anchor: Int?, type: ChatType) async throws -> ChatMessages? {
        if shouldThrow {
            throw VVDomainError.genericError
        }
        return .empty
    }
    
    func markChatThreadMessagesAsRead(messageIDs: [Int], queueID: String, chatType: ChatType) async throws -> Bool {
        if shouldThrow {
            throw VVDomainError.genericError
        }
        return true
    }
}


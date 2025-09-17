//
//  MockChatPollingRepository.swift
//  Virgin Voyages
//
//  Created by TX on 5.8.25.
//

import XCTest
@testable import Virgin_Voyages

class MockChatPollingRepository: ChatPollingRepositoryProtocol {
    var registerForPollingResult: Result<RegisterForChatPollingResponse, Error>?
    var pollChatMessagesResult: Result<PollChatMessagesResponse?, Error>?
    var shouldPollFail = false

    private(set) var registerForPollingCallCount = 0
    private(set) var pollChatMessagesCallCount = 0

    func registerForPolling() async throws -> RegisterForChatPollingResponse {
        registerForPollingCallCount += 1
        guard let result = registerForPollingResult else {
            throw NSError(domain: "No mock result provided", code: -1)
        }
        return try result.get()
    }

    func pollChatMessages(queueID: String, lastEventID: Int) async throws -> PollChatMessagesResponse? {
        pollChatMessagesCallCount += 1
        if shouldPollFail {
            throw NSError(domain: "Polling error", code: -1)
        }
        guard let result = pollChatMessagesResult else {
            throw NSError(domain: "No mock result provided", code: -1)
        }
        return try result.get()
    }
}


extension PollChatMessagesResponse {
    /// Helper method to create mock `PollChatMessagesResponse` with event IDs
    static func mockWithEvents(eventIDs: [Int]) -> PollChatMessagesResponse {
        let events = eventIDs.map { id in
            Event(type: "message", id: id)
        }

        return PollChatMessagesResponse(
            result: "success",
            msg: nil,
            events: events,
            queue_id: "mockQueueID"
        )
    }
}

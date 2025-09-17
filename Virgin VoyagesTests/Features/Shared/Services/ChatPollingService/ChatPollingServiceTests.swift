//
//  ChatPollingServiceTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 5.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class ChatPollingServiceTests: XCTestCase {

    private var service: ChatPollingService!
    private var mockRepository: MockChatPollingRepository!
    private var mockNotificationService: MockChatThreadEventsNotificationService!

    override func setUp() {
        super.setUp()
        mockRepository = MockChatPollingRepository()
        mockNotificationService = MockChatThreadEventsNotificationService()
        service = ChatPollingService(
            chatPollingRepository: mockRepository,
            eventNotificationService: mockNotificationService
        )
    }

    override func tearDown() {
        service.stopPolling()
        service = nil
        mockRepository = nil
        mockNotificationService = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    func testStartPollingSuccessfullySetsActiveState() async throws {
        // Testing that polling starts correctly and sets isPollingActive to true
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 1))

        try await service.startPolling()

        XCTAssertTrue(service.isPollingActive, "Polling should be active after startPolling is called")
    }

    func testPollingStopsAfterMaxRetriesReached() async throws {
        // Testing polling stops after exceeding maximum retries
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 1))
        mockRepository.shouldPollFail = true

        try await service.startPolling()

        try await Task.sleep(nanoseconds: UInt64(16_000_000_000)) // Wait slightly longer than total retries (5s per retry)

        XCTAssertFalse(service.isPollingActive, "Polling should stop after exceeding max retries")
        XCTAssertEqual(mockRepository.pollChatMessagesCallCount, service.maxPollingRetries, "Should retry polling exactly maxPollingRetries times")
    }

    func testStopPollingCancelsTaskAndResetsState() async throws {
        // Testing stopPolling cancels ongoing tasks and resets states
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 1))
        
        try await service.startPolling()
        
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        service.stopPolling()
        
        XCTAssertFalse(service.isPollingActive, "Polling should no longer be active after stopping")
        XCTAssertNil(service.queueID, "queueID should be nil after stopping")
        XCTAssertNil(service.pollingTask, "pollingTask should be nil after stopping")
    }

    func testPollingReceivesEventsAndUpdatesLastEventId() async throws {
        // Testing polling successfully processes events and updates lastEventId
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 100))
        mockRepository.pollChatMessagesResult = .success(PollChatMessagesResponse.mockWithEvents(eventIDs: [101, 102]))

        try await service.startPolling()

        try await Task.sleep(nanoseconds: 2_000_000_000)

        XCTAssertEqual(service.lastEventId, 102, "lastEventId should be updated to the latest event id received")
        XCTAssertTrue(mockNotificationService.publishedEvents.contains(.newMessageReceived), "Notification should be published upon receiving new events")
    }

    func testPollingContinuesOnEmptyEventsResponse() async throws {
        // Testing polling continues normally when empty events are returned
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 100))
        mockRepository.pollChatMessagesResult = .success(PollChatMessagesResponse.mockWithEvents(eventIDs: []))

        try await service.startPolling()

        try await Task.sleep(nanoseconds: 2_000_000_000)

        XCTAssertTrue(service.isPollingActive, "Polling should remain active after receiving empty events response")
        XCTAssertEqual(service.pollingErrorCount, 0, "pollingErrorCount should remain zero when no errors occur")
    }

    func testResumePollingIfNeededWhenNotActive() async throws {
        // Testing resumePollingIfNeeded restarts polling if currently inactive
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 1))
        service.isPollingActive = false

        service.resumePollingIfNeeded()

        try await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertTrue(service.isPollingActive, "Polling should restart if not active when app enters foreground")
    }

    func testResumePollingIfNeededWhenAlreadyActive() async throws {
        // Testing resumePollingIfNeeded does nothing if polling already active
        mockRepository.registerForPollingResult = .success(RegisterForChatPollingResponse(result: "success", msg: nil, queue_id: "validQueueID", last_event_id: 1))

        try await service.startPolling()
        service.resumePollingIfNeeded()

        try await Task.sleep(nanoseconds: 1_000_000_000)

        XCTAssertEqual(mockRepository.registerForPollingCallCount, 1, "Should not re-register if already polling")
    }
}



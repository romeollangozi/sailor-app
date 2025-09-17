//
//  ChatPollingService.swift
//  Virgin Voyages
//
//  Created by TX on 20.2.25.
//

import Foundation
import UIKit

protocol ChatPollingServiceProtocol {
    func startPolling() async throws
    func stopPolling()
    var isPollingActive: Bool { get set }
}

class ChatPollingService: ChatPollingServiceProtocol {
    static let shared = ChatPollingService()

    private let chatPollingRepository: ChatPollingRepositoryProtocol
    private let eventNotificationService: ChatThreadEventsNotificationService
    private(set) var queueID: String?
    private(set) var lastEventId: Int = -1
    var pollingTask: Task<Void, Never>?
    var isPollingActive: Bool = false
    var pollingErrorCount = 0
    let maxPollingRetries = 3

    private var foregroundObserver: Any?
    private var backgroundObserver: Any?
    private var hasBeenInBackground = false

    init(
        chatPollingRepository: ChatPollingRepositoryProtocol = ChatPollingRepository(),
        eventNotificationService: ChatThreadEventsNotificationService = .shared
    ) {
        self.chatPollingRepository = chatPollingRepository
        self.eventNotificationService = eventNotificationService
        setupAppStateObservers()
    }

    deinit {
        removeAppStateObservers()
    }

    private func setupAppStateObservers() {
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            guard self.hasBeenInBackground else { return }
            self.resumePollingIfNeeded()
        }

        backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.hasBeenInBackground = true
            self.stopPolling()
        }
    }

    private func removeAppStateObservers() {
        if let foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
        if let backgroundObserver {
            NotificationCenter.default.removeObserver(backgroundObserver)
        }
    }

    func startPolling() async throws {
        guard !isPollingActive else {
            print("ChatPollingService - Polling already active.")
            return
        }

        isPollingActive = true
        pollingErrorCount = 0

        pollingTask = Task {
            while isPollingActive {
                do {
                    if queueID == nil {
                        try await registerForPolling()
                    }

                    guard let queueID else {
                        throw ChatPollError.queueIDNotFound
                    }

                    try await poll(queueID: queueID, lastEventID: lastEventId)

                    // reset error count after successful poll
                    pollingErrorCount = 0

                } catch ChatPollError.badQueueError {
                    print("ChatPollingService - Queue expired, re-registering.")
                    queueID = nil
                } catch {
                    pollingErrorCount += 1
                    print("ChatPollingService - Polling error (\(pollingErrorCount)/\(maxPollingRetries)): \(error)")

                    if pollingErrorCount >= maxPollingRetries {
                        print("ChatPollingService - Exceeded max retries. Stopping polling.")
                        stopPolling()
                        break
                    } else {
                        try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 sec delay before retry
                    }
                }
            }
        }
    }

    func stopPolling() {
        print("ChatPollingService - Stopping polling...")
        isPollingActive = false
        queueID = nil
        pollingTask?.cancel()
        pollingTask = nil
        pollingErrorCount = 0
    }

    func resumePollingIfNeeded() {
        Task {
            if !isPollingActive {
                try? await startPolling()
            }
        }
    }

    private func registerForPolling() async throws {
        let registerResponse = try await chatPollingRepository.registerForPolling()
        guard let newQueueID = registerResponse.queue_id else {
            throw ChatPollError.queueIDNotFound
        }

        queueID = newQueueID
        lastEventId = registerResponse.last_event_id ?? -1

        print("ChatPollingService - Registered. Queue ID: \(queueID!)")
    }

    private func poll(queueID: String, lastEventID: Int) async throws {
        let response = try await chatPollingRepository.pollChatMessages(queueID: queueID, lastEventID: lastEventID)

        guard let events = response?.events, !events.isEmpty else {
            return
        }

        let sortedEvents = events.compactMap { $0.id }.sorted()
        guard let latestEventID = sortedEvents.last else {
            return
        }

        if latestEventID != lastEventId {
            lastEventId = latestEventID
            eventNotificationService.publish(.newMessageReceived)
        }
    }
}

extension ChatPollingService {
    enum ChatPollError: Error {
        case alreadyRunning
        case queueIDNotFound
        case badQueueError
        case pollingFailed
        case domainError(error: VVDomainError)
        case unknownError(error: Error)
    }
}

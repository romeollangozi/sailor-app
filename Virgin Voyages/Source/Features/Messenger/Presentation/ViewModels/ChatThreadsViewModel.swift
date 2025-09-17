//
//  ChatThreadsViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 14.2.25.
//

import Foundation
import SwiftUI
import VVUIKit

@Observable class ChatThreadsViewModel: BaseViewModelV2, ChatThreadsViewModelProtocol {
    
    let appCoordinator: CoordinatorProtocol
    var chatThreads: [ChatThread] = []
    var isLoading: Bool = false
    var hasError: Bool = false
    var messengerErrorViewModel: MessengerErrorRetryViewModelProtocol
    
    private let getChatThreadsUseCase: GetChatThreadsUseCaseProtocol
    nonisolated private let chatThreadEventsNotificationService: ChatThreadEventsNotificationService
    nonisolated private let listenerKey = "ChatThreadsViewModel"

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         messengerErrorViewModel: MessengerErrorRetryViewModelProtocol = MessengerErrorViewModel(),
         getChatThreadsUseCase: GetChatThreadsUseCaseProtocol = GetChatThreadsUseCase(),
         chatThreadEventsNotificationService: ChatThreadEventsNotificationService = .shared) {

        self.appCoordinator = appCoordinator
        self.getChatThreadsUseCase = getChatThreadsUseCase
        self.chatThreadEventsNotificationService = chatThreadEventsNotificationService
        self.messengerErrorViewModel = messengerErrorViewModel
        
        super.init()
        startObservingEvents()
    }

    func fetchChatThreads() {
        if isFirstLaunch || hasError{
            isLoading = true
        }
        hasError = false
        Task {
            if let result = await executeUseCase({
                try await self.getChatThreadsUseCase.execute()
            }) {
                self.chatThreads = result
                self.isLoading = false
                self.isFirstLaunch = false
                self.messengerErrorViewModel.reset()
            } else {
                self.hasError = true
                self.isLoading = false
                self.isFirstLaunch = false
            }
        }
    }
    
    override func handleError(_ error: any VVError) {
        self.hasError = true
    }
    
    func chatThreadCellTapped(id: String) {
        if let chatThread = chatThreads.first(where: { $0.id == id }) {
            appCoordinator.executeCommand(MessengerCoordinator.OpenChatThreadsCommand(chatThread: chatThread))
        }
    }
    
    func descriptionTextForChatThread(chatThread: ChatThread) -> String {
        if chatThread.isClosed {
            return closedChatDescription
        } else {
            return chatThread.description.value
        }
    }
    
    private var closedChatDescription: String {
        "Thread closed"
    }
    
    // MARK: - Application Event Service
    deinit {
        stopObservingEvents()
    }

    // MARK: - Event Handling
    nonisolated func stopObservingEvents() {
        chatThreadEventsNotificationService.stopListening(key: listenerKey)
    }
    
    func startObservingEvents() {
        
        chatThreadEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_: ChatThreadEventNotification) {
        fetchChatThreads()
    }

    func tryAgainTapped() {
        isLoading = true
        hasError = false
        messengerErrorViewModel.registerAttempt()
        fetchChatThreads()
    }
}

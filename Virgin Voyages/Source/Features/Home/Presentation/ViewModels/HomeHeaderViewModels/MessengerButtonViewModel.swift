//
//  MessengerButtonViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation
import Observation

@Observable class MessengerButtonViewModel: BaseViewModel, MessengerButtonViewModelProtocol {

    // MARK: - Properties 
    var unreadMessagesCount: Int = 0
    
    private var getHomeUnreadMessagesUseCase: GetHomeUnreadMessagesUseCaseProtocol
    private var chatThreadEventsNotificationService: ChatThreadEventsNotificationService
    private var listenerKey = "MessengerButtonViewModel"

    // MARK: - Init
    init(getHomeUnreadMessagesUseCase: GetHomeUnreadMessagesUseCaseProtocol = GetHomeUnreadMessagesUseCase(),
         chatThreadEventsNotificationService: ChatThreadEventsNotificationService = .shared) {
        self.getHomeUnreadMessagesUseCase = getHomeUnreadMessagesUseCase
        self.chatThreadEventsNotificationService = chatThreadEventsNotificationService
        
        super.init()
        
    }
    
    // MARK: - API
    func onAppear() {
        loadUnreadMessages()
        if isFirstLaunch {
            startObservingEvents()
        }
    }
    
    // MARK: - Private Methods
    private func loadUnreadMessages() {
        
        Task { [weak self] in
            guard let self else { return }
            
            if let result = await executeUseCase({
                try await self.getHomeUnreadMessagesUseCase.execute()
            }) {
                
                await executeOnMain {
                    self.unreadMessagesCount = result.total
                }
            }
        }
    }


    // MARK: - Event Handling
    func startObservingEvents() {
        chatThreadEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_: ChatThreadEventNotification) {
        loadUnreadMessages()
    }
    
    deinit {
        chatThreadEventsNotificationService.stopListening(key: listenerKey)
    }
}


// MARK: - Mock ViewModel

class MessengerButtonMockViewModel: MessengerButtonViewModelProtocol {

    var unreadMessagesCount: Int
    
    init(unreadMessagesCount: Int) {
        self.unreadMessagesCount = unreadMessagesCount
    }
    
    func onAppear() {}
}

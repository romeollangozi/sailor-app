//
//  ChatPollingRepository.swift
//  Virgin Voyages
//
//  Created by TX on 21.2.25.
//

import Foundation

protocol ChatPollingRepositoryProtocol {
    func registerForPolling() async throws -> RegisterForChatPollingResponse
    func pollChatMessages(queueID: String, lastEventID: Int) async throws -> PollChatMessagesResponse?
}


class ChatPollingRepository: ChatPollingRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.createZulipService()) {
        self.networkService = networkService
    }
    
    func registerForPolling() async throws -> RegisterForChatPollingResponse {
        return try await networkService.registerForPolling(input: RegisterForChatPollingBody())
    }
    
    func pollChatMessages(queueID: String, lastEventID: Int) async throws -> PollChatMessagesResponse? {
        return try await networkService.pollChatMessages(queueID: queueID, lastEventID: lastEventID)
    }
}

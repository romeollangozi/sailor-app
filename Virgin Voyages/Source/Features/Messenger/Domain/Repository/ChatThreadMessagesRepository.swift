//
//  ChatThreadMessagesRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.2.25.
//

import Foundation

protocol ChatThreadMessagesRepositoryProtocol {
    func fetchChatThreadMessages(threadId: String, voyageNumber: String, sailorId: String, pageSize: Int, anchor: Int?, type: ChatType)  async throws -> ChatMessages?

    func markChatThreadMessagesAsRead(messageIDs: [Int], queueID: String, chatType: ChatType)  async throws -> Bool
}

class ChatThreadMessagesRepository: ChatThreadMessagesRepositoryProtocol {

    private let networkService: NetworkServiceProtocol
    private let zulipNetworkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create(),
         zulipNetworkService: NetworkServiceProtocol = NetworkService.createZulipService()) {
        self.networkService = networkService
        self.zulipNetworkService = zulipNetworkService
    }
    
    func fetchChatThreadMessages(threadId: String,
                                 voyageNumber: String,
                                 sailorId: String,
                                 pageSize: Int,
                                 anchor: Int?,
                                 type: ChatType)  async throws -> ChatMessages? {

		let result = try await networkService.fetchChatThreadMessages(threadId: threadId,
																	  voyageNumber: voyageNumber,
																	  sailorId: sailorId,
																	  pageSize: pageSize,
																	  anchor: anchor,
                                                                      type: type.rawValue)
		guard let messages = result else { return nil }
        return messages.toDomain()
    }
    
    
    
    func markChatThreadMessagesAsRead(messageIDs: [Int], queueID: String, chatType: ChatType) async throws -> Bool {
        
        let operation = "add" // fixed hardcoded value
        let flag = "read"
        if chatType == .sailorServices {
            let input = MarkChatMessageAsReadRequestInput(
                op: operation,
                flag: flag,
                messages: messageIDs,
                queue_id: queueID) // this is queue id or user iamid
            
            _ = try await zulipNetworkService.markChatMessagesAsRead(input: input)
        } else {
            let input = MarkCrewChatMessageAsReadRequestInput(
                op: operation,
                flag: flag,
                messages: messageIDs) // this is queue id or user iamid
            
            _ = try await zulipNetworkService.markCrewChatMessagesAsRead(input: input)
        }
        
        return true
    }
    
}

//
//  MarkChatMessagesAsReadUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 19.5.25.
//

import Foundation

protocol MarkChatMessagesAsReadUseCaseProtocol {
    func execute(messagesIDs: [Int], threadID: String, chatType: ChatType) async throws -> Bool
}

class MarkChatMessagesAsReadUseCase: MarkChatMessagesAsReadUseCaseProtocol {

    private var repository: ChatThreadMessagesRepositoryProtocol
    
    init(repository: ChatThreadMessagesRepositoryProtocol = ChatThreadMessagesRepository()) {
        self.repository = repository
    }
    
    func execute(messagesIDs: [Int], threadID: String, chatType: ChatType) async throws -> Bool {
        return try await repository.markChatThreadMessagesAsRead(messageIDs: messagesIDs, queueID: threadID, chatType: chatType)
    }
}

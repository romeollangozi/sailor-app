//
//  ChatThread+Mapping.swift
//  Virgin Voyages
//
//  Created by TX on 13.2.25.
//

import Foundation

extension ChatThreadResponse.ChatThread {
    func toDomain() -> ChatThread {
        return ChatThread(
            id: self.id.value,
            title: self.title.value,
            unreadCount: self.unreadCount.value,
            isClosed: self.isClosed.value,
            type: self.type?.toDomain() ?? .sailorServices,
            description: self.description,
            lastMessageTime: self.lastMessageTime,
            imageURL: self.imageURL
        )
    }
}

extension ChatThreadResponse.ChatType {
    func toDomain() -> ChatType {
        switch self {
        case .rockStarAgent:
            return .rockStarAgent
        case .sailor:
            return .sailor
        case .sailorServices:
            return .sailorServices
        case .crew:
            return .crew
        }
    }
}

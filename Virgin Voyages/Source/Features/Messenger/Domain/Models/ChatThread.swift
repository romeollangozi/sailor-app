//
//  ChatThread.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.2.25.
//

import Foundation

struct ChatThread : Equatable, Identifiable, Hashable  {
    let id: String
    let title: String
    let unreadCount: Int
    let isClosed: Bool
    let type: ChatType
    let description: String?
    let lastMessageTime: String?
    let imageURL: String?
}

enum ChatType: String {
    case sailorServices = "SailorServices"
    case sailor = "Sailor"
    case rockStarAgent = "RockStarAgent"
    case crew = "Crew"
    
    var title : String {
        switch self {
        case .sailorServices:
            "Sailor Services"
        case .sailor:
            "Sailor"
        case .rockStarAgent:
            "Rockstar"
        case .crew:
            "Crew"
        }
    }
    
    var description : String {
        switch self {
        case .sailorServices:
            "Sailor Services Chat"
        case .sailor:
            "Sailor Chat"
        case .rockStarAgent:
            "Rockstar Chat"
        case .crew:
            "Crew chat"
        }
    }
}

extension ChatThread {
    static func sample() -> ChatThread {
        return ChatThread(
            id: UUID().uuidString,
            title: "Sailor Services",
            unreadCount: Int.random(in: 0...10),
            isClosed: false,
            type: .sailorServices,
            description: "Hey, i need help with my next voyage",
            lastMessageTime: "1.25pm",
            imageURL: nil
        )
    }
    
    static func samples() -> [ChatThread] {
        return [
            ChatThread(
                id: UUID().uuidString,
                title: "Sailor Services",
                unreadCount: 0,
                isClosed: true,
                type: .sailorServices,
                description: "Thread closed",
                lastMessageTime: "3.25pm",
                imageURL: nil
            ),
            ChatThread(
                id: UUID().uuidString,
                title: "Sailor Services",
                unreadCount: 0,
                isClosed: true,
                type: .sailorServices,
                description: "Thread closed",
                lastMessageTime: "3.25pm",
                imageURL: nil
            ),
            ChatThread(
                id: UUID().uuidString,
                title: "Spa Guru",
                unreadCount: 0,
                isClosed: true,
                type: .sailorServices,
                description: "Thread closed",
                lastMessageTime: "4.25pm",
                imageURL: nil
            )
        ]
    }
    
    static func sample(
        id: String = "",
        title: String = "",
        unreadCount: Int = 0,
        isClosed: Bool = false,
        type: ChatType = .sailorServices,
        description: String = "",
        lastMessageTime: String = "",
        imageURL: String? = nil) -> ChatThread {
        
        return ChatThread(id: id, title: title, unreadCount: unreadCount, isClosed: isClosed, type: type, description: description, lastMessageTime: lastMessageTime, imageURL: imageURL)
    }

}

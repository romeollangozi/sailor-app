//
//  SailorData.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

import Foundation

struct SailorChatData {
    let result: String
    let msg: String
    let id: Int
    let sailorIamUserId: String
    let subject: String
    let status: String
    let loyalty: String
    let cabinNumber: String
    let ownedBy: String
    let requiresAttention: Bool
    let creationTime: Int
    let firstMessageTime: Int
    let streamId: Int
    let voyageNumber: String
    let resolvedAt: String
    let lastMessageContent: String
    let lastMessageTime: Int
    let lastMessageSenderIamId: String
    let lastMessageSenderTime: Int
    let isUserAccountMerged: Bool
}


extension SailorChatData {
    static func mock() -> SailorChatData {
        return SailorChatData(
            result: "success",
            msg: "Mock message",
            id: 1377,
            sailorIamUserId: "4e6ea19a-fdf0-4aa8-8c0e-92bb4dead244",
            subject: "Mock Subject",
            status: "in_progress",
            loyalty: "Gold",
            cabinNumber: "12345A",
            ownedBy: "Mock Owner",
            requiresAttention: false,
            creationTime: Int(Date().timeIntervalSince1970),
            firstMessageTime: Int(Date().timeIntervalSince1970) + 10,
            streamId: 5678,
            voyageNumber: "SC2502088NCP",
            resolvedAt: "Not Resolved",
            lastMessageContent: "This is a mock message content",
            lastMessageTime: Int(Date().timeIntervalSince1970) + 20,
            lastMessageSenderIamId: "mock-sender-id",
            lastMessageSenderTime: Int(Date().timeIntervalSince1970) + 15,
            isUserAccountMerged: false
        )
    }
}

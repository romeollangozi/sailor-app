//
//  ChatMessages.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

import Foundation

struct ChatMessagesModel {
	let items: [ChatMessages.ChatMessage]
    let nextAnchor: Int
    let hasMore: Bool
    let headerTitle: String
    let headerSubtitle: String
    let sailiorImage: String

}

extension ChatMessagesModel {
    static let empty = ChatMessagesModel(
        items: [],
        nextAnchor: 0,
        hasMore: false,
        headerTitle: "",
        headerSubtitle: "",
        sailiorImage: ""
    )

    // Mock data for testing
    static let mock = ChatMessagesModel(
        items: [
            ChatMessages.ChatMessage(id: 1, content: "<p>Hello</p>", contentArray: [], isMine: false, type: .html,  createdAt: "2025-02-13T10:32:10"),
            ChatMessages.ChatMessage(id: 2, content: "<p>Ahoy, Sailor! Someone from our crew will be with you shortly. </p>", contentArray: [], isMine: false, type: .html, createdAt: "2025-02-13T10:32:11"),
            ChatMessages.ChatMessage(id: 3, content: "", contentArray: ["url1", "url2"], isMine: true, type: .image, createdAt: "2025-02-13T10:32:36")
        ],
        nextAnchor: 0,
        hasMore: true,
        headerTitle: "Crew Chat",
        headerSubtitle: "You're chatting with our crew",
        sailiorImage: "ServiceAvatarImage"
    )
}

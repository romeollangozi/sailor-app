//
//  ChatMessages.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

struct ChatMessages {
    let items: [ChatMessage]
    let nextAnchor: Int
    let hasMore: Bool
    
	struct ChatMessage: Hashable {
        let id: Int
        let content: String
        let contentArray: [String]
        let isMine: Bool
        let type: ChatMessageType
        let createdAt: String
        
        enum ChatMessageType: String {
            case undefined = ""
            case html = "Html"
            case image = "Image"
        }
    }
}

extension ChatMessages {
    static let empty = ChatMessages(
        items: [],
        nextAnchor: 0,
        hasMore: false
    )
    static let sample = ChatMessages(
        items: [
            ChatMessage(id: 1, content: "<p>Hello</p>", contentArray: [], isMine: false, type: .html, createdAt: "2025-02-13T10:32:10"),
            ChatMessage(id: 2, content: "<p>Ahoy, Sailor! Someone from our crew will be with you shortly. 🚢</p>", contentArray: [], isMine: false, type: .html, createdAt: "2025-02-13T10:32:11"),
            ChatMessage(id: 3, content: "", contentArray: ["imageURL1", "imageURL2", "imageURL3"], isMine: false, type: .image, createdAt: "2025-02-13T10:32:36")
        ],
        nextAnchor: 0,
        hasMore: true
    )
}

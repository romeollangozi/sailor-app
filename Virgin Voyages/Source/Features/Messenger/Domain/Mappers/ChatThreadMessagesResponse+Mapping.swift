//
//  ChatThreadMessagesResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//


extension GetChatThreadMessagesResponse {
    func toDomain() -> ChatMessages {
        return ChatMessages(
            items: self.items?.compactMap { item in
                if let id = item.id,
                   let isMine = item.isMine,
                   let type = item.type,
                   let createdAt = item.createdAt {
                    
                    // map messageType
                    let messageType = ChatMessages.ChatMessage.ChatMessageType(rawValue: type) ?? .undefined
                    
                    // Map the content (string or [string])
                    var stringContent = ""
                    var imageURLsContent: [String] = []
                    
                    switch item.content {
                    case .string(let singleStringContent):
                        stringContent = singleStringContent
                    case .array(let stringArray):
                        imageURLsContent = stringArray
                    default: break
                    }
                    
                    return ChatMessages.ChatMessage(
                        id: id,
                        content: stringContent,
                        contentArray: imageURLsContent,
                        isMine: isMine,
                        type: messageType,
                        createdAt: createdAt
                    )
                }
                return nil
            } ?? [],
            nextAnchor: self.nextAnchor.value,
            hasMore: self.hasMore ?? false
        )
    }
}

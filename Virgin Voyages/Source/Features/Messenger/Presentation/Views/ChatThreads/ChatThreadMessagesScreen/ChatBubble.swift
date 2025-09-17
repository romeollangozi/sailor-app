//
//  ChatBubble.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.2.25.
//

import SwiftUI
import VVUIKit

enum BubbleType {
	case single, top, middle, bottom, topBottom
}

struct ChatBubble: View {
    let message: ChatMessages.ChatMessage
    let type: BubbleType
    let isFirst: Bool
    let isLast: Bool
    var isSend: Bool
    let onImageTap: ((_ imageData: Data) -> Void)?
    
    init(message: ChatMessages.ChatMessage, type: BubbleType, isFirst: Bool, isLast: Bool, isSend: Bool = true, onImageTap: ((_: Data) -> Void)? = nil) {
        self.message = message
        self.type = type
        self.isFirst = isFirst
        self.isLast = isLast
        self.isSend = isSend
        self.onImageTap = onImageTap
    }

    var body: some View {
        VStack {
            HStack {
                if message.isMine { Spacer() }
                switch message.type {
                case .html, .undefined:
                    messageTextView(message)
                case .image:
                    imagesView(message)
                }
                
                if !message.isMine { Spacer() }
            }

            if !isSend {
                HStack {
                    if message.isMine { Spacer() }
                    NotDeliveredView()
                    if !message.isMine { Spacer() }
                }
            }
        }
    }
    
    @ViewBuilder
    private func messageTextView(_ message: ChatMessages.ChatMessage) -> some View {
        Text(message.content.plainText)
            .font(.vvHeading5)
            .padding()
            .background(bubbleColor(message: message))
            .clipShape(CustomBubbleShape(isMine: message.isMine, type: type, isFirst: isFirst, isLast: isLast))
            .fixedSize(horizontal: false, vertical: true)
            .frame(
                maxWidth: UIScreen.main.bounds.width * 0.7,
                alignment: message.isMine ? .trailing : .leading
            )
    }
    
    @ViewBuilder
    private func imagesView(_ message: ChatMessages.ChatMessage) -> some View {
        VStack(alignment: message.isMine ? .trailing : .leading, spacing: Spacing.space8) {
            ForEach(message.contentArray, id: \.self) { urlString in
                AuthURLImageView(
                    imageUrl: urlString,
                    size: 262.0,
                    height: 174.0,
                    defaultImage: "",
                    onImageTap: { imageData in
                        (onImageTap ?? {_ in})(imageData)
                    }
                )
                    .padding(.zero)
                    .background(.blue)
                    .clipShape(CustomBubbleShape(isMine: message.isMine, type: type, isFirst: isFirst, isLast: isLast))
                    .frame(
                        maxWidth: 262.0,
                        alignment: message.isMine ? .trailing : .leading
                    )
            }
        }
        .padding(.zero)

    }

    private func bubbleColor(message: ChatMessages.ChatMessage) -> Color {
        return message.isMine ? Color.vvTropicalBlue : .white
    }
}

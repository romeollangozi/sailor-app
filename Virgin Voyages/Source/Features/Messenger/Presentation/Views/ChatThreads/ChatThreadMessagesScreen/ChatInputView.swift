//
//  ChatInputView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.2.25.
//

import SwiftUI
import VVUIKit

struct ChatInputView: View {
	@Binding var messageText: String
    var isKeyboardShown: FocusState<Bool>.Binding
    var isExecuting: Binding<Bool>
    
	var sendMessage: () -> Void
	var uploadPhoto: () -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			Rectangle()
				.fill(Color.slateGray.opacity(0.3))
				.frame(height: 1)
			
			HStack(alignment: .center, spacing: Spacing.space8) {
				TextField("Message", text: $messageText)
					.font(.vvBody)
					.foregroundStyle(Color.slateGray)
					.padding(Spacing.space8)
					.background(Color.white)
					.clipShape(RoundedRectangle(cornerRadius: Spacing.space8))
					.overlay(
						RoundedRectangle(cornerRadius: Spacing.space8)
							.stroke(Color.slateGray.opacity(0.3), lineWidth: 1)
					)
					.padding(.horizontal)
					.padding(.vertical, Spacing.space4)
                    .focused(isKeyboardShown)

				
				Button(action: sendMessage) {
					Image("Send")
						.resizable()
						.renderingMode(.template)
						.foregroundColor(messageText.isEmpty ? Color.borderGray : Color.vvRed)
						.frame(width: Spacing.space32, height: Spacing.space32)
						.padding(.trailing)
				}
                .disabled(messageText.isEmpty || isExecuting.wrappedValue)
				.padding(.vertical, Spacing.space8)
			}
			.background(Color.white)
			.ignoresSafeArea(edges: .bottom)
		}
	}
}

// MARK: - Preview
struct ChatInputView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @FocusState private var isKeyboardShown: Bool
        @State private var text: String = ""

        var body: some View {
            ChatInputView(
                messageText: $text,
                isKeyboardShown: $isKeyboardShown,
                isExecuting: .constant(false),
                sendMessage: { print("Send tapped") },
                uploadPhoto: { print("Upload tapped") }
            )
            .onAppear {
                isKeyboardShown = false
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .background(Color.gray.opacity(0.1))
    }
}

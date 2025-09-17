//
//  ChatThreadMessagesScreen.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.2.25.
//

import SwiftUI
import VVUIKit

// MARK: - ViewModel Protocol
protocol ChatThreadMessagesScreenViewModelProtocol {
    var chatMessagesModel: ChatMessagesModel { get }
    var inputMessage: String { get set }
    var screenState: ScreenState { get set }
    var keyboardHeight: CGFloat { get }
    var scrollToBottom: Bool { get }
    var chatThread: ChatThread { get }
    var closedThreadText: String { get }
    var isSendingMessageInProgress: Bool { get set }
    var isInputFocused: Bool { get set }
    var shouldShowFullScreenImagePreview: Bool { get set }
    var fullScreenPreviewImageData: Data? { get }
    var messengerErrorViewModel: MessengerErrorRetryViewModelProtocol { get }
    
    func navigateBack()
    func onAppear()
    func sendMessage()
    func triggerScrollToBottom()
    func resetScrollToBottom()
    func toggleFullScreenImagePreview(imageData: Data?)
    func tryAgainTapped()
}

// MARK: - ChatThreadMessagesScreen
struct ChatThreadMessagesScreen: View {
    
    // MARK: - Properties
    @State private var viewModel: ChatThreadMessagesScreenViewModelProtocol
    @FocusState private var isKeyboardShown: Bool
    
    // MARK: - Initializers
    init(viewModel: ChatThreadMessagesScreenViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    init(chatThread: ChatThread) {
        _viewModel = State(wrappedValue: ChatThreadMessagesScreenViewModel(chatThread: chatThread))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                headerView()
               
                if viewModel.screenState == .loading {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else {
                    if viewModel.screenState == .error {
                        errorView()
                    } else {
                        messagesListView()
                        if viewModel.chatThread.isClosed {
                            chatClosedView()
                        } else {
                            chatInputView()
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.softGray)
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: isKeyboardShown, { oldValue, newValue in
            viewModel.isInputFocused = newValue
        })
        .onChange(of: viewModel.isInputFocused, { oldValue, newValue in
            isKeyboardShown = newValue
        })
        .fullScreenCover(isPresented: $viewModel.shouldShowFullScreenImagePreview) {
            MessengerFullScreenImageView(
                imageData: viewModel.fullScreenPreviewImageData,
                onDismiss: {
                    viewModel.shouldShowFullScreenImagePreview = false
                }
            )
        }
    }
    
    private func errorView() -> some View {
        VStack(spacing: Paddings.defaultVerticalPadding16) {
            VStack {
                MessengerErrorView(
                    viewModel: viewModel.messengerErrorViewModel,
                    onTryAgain: { viewModel.tryAgainTapped() }
                )
                .padding(Paddings.defaultVerticalPadding24)
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Header View
    private func headerView() -> some View {
        HStack(spacing: Spacing.space16) {
            BackButton({
                viewModel.navigateBack()
            }, isCircleButton: false)
            
            if !viewModel.chatMessagesModel.sailiorImage.isEmpty {
                Image(viewModel.chatMessagesModel.sailiorImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Spacing.space32, height: Spacing.space32)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(.vvDarkGray) // You can customize the fallback color
                        .frame(width: Spacing.space32, height: Spacing.space32)
                    
                    Text(String(viewModel.chatMessagesModel.headerTitle.prefix(1)).uppercased())
                        .font(.vvBodyMedium)
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: Spacing.space2) {
                Text(viewModel.chatMessagesModel.headerTitle)
                    .font(.vvBodyMedium)
                    .foregroundStyle(Color.vvBlack)
                
                Text(viewModel.chatMessagesModel.headerSubtitle)
                    .font(.vvSmallLight)
                    .foregroundStyle(Color.vvGray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, Paddings.defaultVerticalPadding)
        .background(Color.white)
    }
    
    // MARK: - Messages List View (Scrolls to Latest)
    private func messagesListView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.space8) {
                    ForEach(viewModel.chatMessagesModel.items, id: \.id) { message in
                        ChatBubble(
                            message: message,
                            type: .single,
                            isFirst: true,
                            isLast: true,
                            onImageTap: { imageData in
                                viewModel.toggleFullScreenImagePreview(imageData: imageData)
                            }
                        )
                        .id(message.id)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .onChange(of: viewModel.scrollToBottom, { oldValue, newValue in
                if newValue {
                    scrollToMessage(proxy: proxy, message: viewModel.chatMessagesModel.items.last)
                }
            })
            .onChange(of: viewModel.chatMessagesModel.items.count) {
                scrollToMessage(proxy: proxy, message: viewModel.chatMessagesModel.items.last)
            }
            .onAppear {
                if viewModel.scrollToBottom, let lastMessage = viewModel.chatMessagesModel.items.last {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                        viewModel.resetScrollToBottom()
                    }
                }
            }
        }
    }
    
    // MARK: - Chat Input View
    private func chatInputView() -> some View {
        ChatInputView(
            messageText: $viewModel.inputMessage,
            isKeyboardShown: $isKeyboardShown,
            isExecuting: $viewModel.isSendingMessageInProgress,
            sendMessage: {
                viewModel.sendMessage()
            },
            uploadPhoto: {}
        )
        .animation(.easeOut(duration: 0.3), value: viewModel.keyboardHeight)
    }
    
    private func chatClosedView() -> some View {
        VStack(alignment: .center) {
            Text(viewModel.closedThreadText)
                .padding(.vertical, Spacing.space8)
                .padding(.horizontal, Spacing.space16)
                .frame(height: Spacing.space32)
                .font(.vvSmall)
                .foregroundColor(.vvGray)
                .background(.white)
                .cornerRadius(8, corners: .allCorners)
        }
        .padding()
    }
    
    private func scrollToMessage(proxy: ScrollViewProxy, message: ChatMessages.ChatMessage?) {
        if viewModel.scrollToBottom, let message {
            withAnimation {
                proxy.scrollTo(message.id, anchor: .bottom)
            }
            viewModel.resetScrollToBottom()
        }
    }
}

// MARK: - Preview
#Preview {
    let mockViewModel = MockChatThreadMessagesScreenViewModel(screenState: .error)
    return ChatThreadMessagesScreen(viewModel: mockViewModel)
}

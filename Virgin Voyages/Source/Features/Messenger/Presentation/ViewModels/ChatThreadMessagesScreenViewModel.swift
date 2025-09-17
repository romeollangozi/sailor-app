//
//  ChatThreadMessagesScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 14.2.25.
//

import Observation
import UIKit
import VVUIKit

@Observable
class ChatThreadMessagesScreenViewModel: BaseViewModel, ChatThreadMessagesScreenViewModelProtocol {
	// MARK: - Dependencies
	private let getChatThreadMessagesUseCase: GetChatThreadMessagesUseCaseProtocol
    private let getChatThreadsUseCase: GetChatThreadsUseCaseProtocol
	private let sendMessageUseCase: SendMessageUseCaseProtocol
    private let markMessagesAsReadUseCase: MarkChatMessagesAsReadUseCaseProtocol
	private let initialAnchor = 9007199254740991

	// MARK: - Published Properties
	var chatMessagesModel: ChatMessagesModel
	var screenState: ScreenState
	var inputMessage: String = ""
	var keyboardHeight: CGFloat
	private var shouldScrollToBottom: Bool = false
    var isSendingMessageInProgress: Bool = false
    var isInputFocused: Bool = false
    var shouldShowFullScreenImagePreview = false
    var fullScreenPreviewImageData: Data? = nil
    var scrollToBottom: Bool {
		shouldScrollToBottom
	}

	// MARK: - App Coordinator
	private let appCoordinator: AppCoordinator = .shared

    private var chatThreadEventsNotificationService: ChatThreadEventsNotificationService
    private var listenerKey = "ChatThreadMessagesScreenViewModel"

    var chatThread: ChatThread
    
    // MARK: - Error handling
    let messengerErrorViewModel: MessengerErrorRetryViewModelProtocol

    
	// MARK: - Initializer
	init(
        chatThread: ChatThread,
		getChatThreadMessagesUseCase: GetChatThreadMessagesUseCaseProtocol = GetChatThreadMessagesUseCase(),
        getChatThreadsUseCase: GetChatThreadsUseCaseProtocol = GetChatThreadsUseCase(),
		sendMessageUseCase: SendMessageUseCaseProtocol = SendMessageUseCase(),
        markMessagesAsReadUseCase: MarkChatMessagesAsReadUseCaseProtocol = MarkChatMessagesAsReadUseCase(),
		chatMessagesModel: ChatMessagesModel = .empty,
		screenState: ScreenState = .loading,
        messengerErrorViewModel: MessengerErrorRetryViewModelProtocol = MessengerErrorViewModel(),
		inputMessage: String = "",
		keyboardHeight: CGFloat = Sizes.zero,
        chatThreadEventsNotificationService: ChatThreadEventsNotificationService = .shared
	) {
		self.getChatThreadMessagesUseCase = getChatThreadMessagesUseCase
        self.getChatThreadsUseCase = getChatThreadsUseCase
		self.sendMessageUseCase = sendMessageUseCase
        self.markMessagesAsReadUseCase = markMessagesAsReadUseCase
		self.chatMessagesModel = chatMessagesModel
		self.screenState = screenState
        self.messengerErrorViewModel = messengerErrorViewModel
		self.inputMessage = inputMessage
		self.keyboardHeight = keyboardHeight
        self.chatThreadEventsNotificationService = chatThreadEventsNotificationService
        self.chatThread = chatThread
        super.init()
        self.startObservingEvents()
	}


	func onAppear() {
        
        if isFirstLaunch {
            setupDefaultHeader()
            screenState = .loading
        } else {
            screenState = .content
        }
        
		Task {
			await loadMessages()
			await executeOnMain {
				observeKeyboardNotifications()
                if chatThread.id.isEmpty {
                    // new chat initiated
                    isInputFocused = true
                }
				triggerScrollToBottom()
			}
		}
	}

    private func setupDefaultHeader() {
        chatMessagesModel = .init(items: [], nextAnchor: 0, hasMore: false, headerTitle: chatThread.title, headerSubtitle: chatThread.type.description, sailiorImage: chatThread.imageURL ?? "")
    }
    
	// MARK: - Message Handling
	private func loadMessages() async {
		if let result = await executeUseCase({ [self] in
			try await self.getChatThreadMessagesUseCase.execute(
                threadId: self.chatThread.id,
				pageSize: 40,
				anchor: initialAnchor,
                title: self.chatThread.title,
                type: self.chatThread.type
			)
		}) {
			await executeOnMain {
                messengerErrorViewModel.reset()
                screenState = .content
				chatMessagesModel = result
				triggerScrollToBottom()   
			}
            markMessagesAsRead()
        } 
		await executeOnMain {
			isFirstLaunch = false
		}
	}
    
    override func handleError(_ error: any VVError) {
        switch error {
        case let messengerError as VVMessengerError:
            switch messengerError {
            case .failedToFetchMessages:
                failedToFetchMessages()
            case .failedToSendMessage:
                // Failed to send message error handling
                // To be implemented...
                break
            }
        default:
            // Generic error handling is not implemented for this screen's view model
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.screenState = .content
            }
            break
        }
    }
    
    private func failedToFetchMessages() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.screenState = .error
        }
    }
    
    // MARK: - Public: Try Again Action
    
    func tryAgainTapped() {
        screenState = .loading
        messengerErrorViewModel.registerAttempt()
        Task { [weak self] in
            guard let self else { return }
            await self.loadMessages()
        }
    }

    
    // MARK: - Reload chat thread
    private func updateChatThread() async {
        if let result = await executeUseCase({ [self] in
            try await self.getChatThreadsUseCase.execute()
        }) {
            if let updatedChatThread = result.first(where: { $0.id == self.chatThread.id }) {
                await executeOnMain {
                    self.chatThread = updatedChatThread
                }
            } else {
                print("ChatThreadMessagesScreenViewModel - UpdateChatThread() Warning: Chat thread not found in updated threads")
            }
        }
    }
        
    func sendMessage() {
        DispatchQueue.main.async {
            self.isSendingMessageInProgress = true
        }
        Task {
            if let _ = await executeUseCase({
                try await self.sendMessageUseCase.execute(message: self.inputMessage, chatType: self.chatThread.type, to: self.chatThread.id)
            }) {
                await executeOnMain {
                    self.inputMessage = ""
                    self.isInputFocused = true
                }

                await self.loadMessages()

                await executeOnMain {
                    self.triggerScrollToBottom()
                    self.isInputFocused = true
                    self.isSendingMessageInProgress = false
                }
            } else {
                await executeOnMain {
                    self.isSendingMessageInProgress = false
                }
            }
        }
    }

    
    private func markMessagesAsRead() {
        Task {
            guard let _ = await executeUseCase({ [weak self] in
                guard let self else { return false }
                // Marking all as read because the chat messages currently do not have isRead status flag.
                let contactMessageIDs = self.chatMessagesModel.items.compactMap { !$0.isMine ? $0.id : nil }
                guard !contactMessageIDs.isEmpty else {
                    // No need to call mark as read if no messages are available
                    // If markMessagesAsReadUseCase is called with an empty contactMessageIDs, the API returns an error.
                    return false
                }
                return try await self.markMessagesAsReadUseCase.execute(
                    messagesIDs: contactMessageIDs, threadID: chatThread.id , chatType: chatThread.type)
            }) else {
                print("ChatThreadMessagesScreenViewModel - Error : Could not mark messages as read")
                return false
            }
            return true
        }
    }

	// MARK: - Scroll Handling
	func triggerScrollToBottom() {
		DispatchQueue.main.async {
			self.shouldScrollToBottom = true
		}
	}

	func resetScrollToBottom() {
		DispatchQueue.main.async {
			self.shouldScrollToBottom = false
		}
	}

	// MARK: - Keyboard Handling
	private func observeKeyboardNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide(_:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	@objc private func keyboardWillShow(_ notification: Notification) {
		if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
			DispatchQueue.main.async {
				self.keyboardHeight = keyboardFrame.height
			}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.triggerScrollToBottom()
            }
		}
	}

	@objc private func keyboardWillHide(_ notification: Notification) {
		DispatchQueue.main.async {
			self.keyboardHeight = Sizes.zero
		}
	}

	// MARK: - Navigation
	func navigateBack() {
		appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
	}
    
    // MARK: - Application Event Service
    deinit {
        NotificationCenter.default.removeObserver(self)
        chatThreadEventsNotificationService.stopListening(key: listenerKey)
    }

    // MARK: - Event Handling
    func startObservingEvents() {
        chatThreadEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_: ChatThreadEventNotification) {
        Task {
            await loadMessages()
            await updateChatThread()
        }
    }
    
    var closedThreadText: String {
        let closedAtText: String = self.chatThread.lastMessageTime != nil ? " " + self.chatThread.lastMessageTime.value.lowercased() : ""
        return "Thread closed" + closedAtText
    }
    
    func toggleFullScreenImagePreview(imageData: Data?) {
        DispatchQueue.main.async {
            self.fullScreenPreviewImageData = imageData
            self.shouldShowFullScreenImagePreview.toggle()
        }
    }
}

// MARK: - Mock ViewModel
class MockMessengerErrroViewModel: MessengerErrorRetryViewModelProtocol {
    var attempts: Int = 0
    var maxAttempts: Int = 0
    var state: MessengerErrorState = .retryAvailable
    var shouldShowRetryButton: Bool = true
    func registerAttempt() {}
    func reset() {}
}

class MockChatThreadMessagesScreenViewModel: ChatThreadMessagesScreenViewModelProtocol {
    
    // MARK: - Properties
    var chatThread: ChatThread = .sample()
	var screenState: ScreenState
	var chatMessagesModel: ChatMessagesModel
	var inputMessage: String
	var keyboardHeight: CGFloat = Sizes.zero
	var scrollToBottom: Bool = false
    var closedThreadText: String = "Above chat was resolved"
    var isSendingMessageInProgress: Bool = false
    var isInputFocused: Bool = false
    var shouldShowFullScreenImagePreview: Bool = false
    var fullScreenPreviewImageData: Data? = nil
    
    
	// MARK: - App Coordinator
	var appCoordinator: AppCoordinator = .shared
    var messengerErrorViewModel: MessengerErrorRetryViewModelProtocol = MockMessengerErrroViewModel()

	// MARK: - Methods
	func sendMessage() {}
	func navigateBack() {}
	func onAppear() {}
	func triggerScrollToBottom() {}
	func resetScrollToBottom() {}
    func toggleFullScreenImagePreview(imageData: Data?) {
        fullScreenPreviewImageData = imageData
        shouldShowFullScreenImagePreview.toggle()
    }
    func tryAgainTapped() {}

	// MARK: - Initializer
	init(
		chatMessagesModel: ChatMessagesModel = ChatMessagesModel.mock,
		inputMessage: String = "Enter message",
		screenState: ScreenState = .content
	) {
		self.chatMessagesModel = chatMessagesModel
		self.inputMessage = inputMessage
		self.screenState = screenState
	}
}

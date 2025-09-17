//
//  ChatThreadViews.swift
//  Virgin Voyages
//
//  Created by TX on 14.2.25.
//

import Foundation
import VVUIKit
import SwiftUI

protocol ChatThreadsViewModelProtocol {
    var chatThreads: [ChatThread] { get set }
    var isLoading: Bool { get set }
    var hasError: Bool { get set }
    var messengerErrorViewModel: MessengerErrorRetryViewModelProtocol { get }
    func fetchChatThreads()
    func chatThreadCellTapped(id: String)
    func descriptionTextForChatThread(chatThread: ChatThread) -> String
    func tryAgainTapped()
}

struct ChatThreadsView: View {
    @State private var viewModel : ChatThreadsViewModelProtocol
    @Binding var viewHasError: Bool
    @Binding var viewIsLoading: Bool
    
    init(viewModel: ChatThreadsViewModelProtocol,
         viewHasError: Binding<Bool>,
         viewIsLoading: Binding<Bool>) {
        _viewModel = .init(wrappedValue: viewModel)
        _viewHasError = viewHasError
        _viewIsLoading = viewIsLoading
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space12) {
            
            Text("Chats")
                .font(.vvHeading5Bold)

            if viewModel.isLoading {
                ProgressView()
                    .padding(.vertical)
                
            } else if viewModel.hasError {
                MessengerErrorView(
                    viewModel: viewModel.messengerErrorViewModel,
                    onTryAgain: { viewModel.tryAgainTapped() }
                )
            } else {
                VStack(alignment: .leading, spacing: Spacing.space0) {
                    ForEach($viewModel.chatThreads) { thread in
                        ListCell(
                            content: ListCellViewModel(
                                id: thread.wrappedValue.id,
                                title: thread.wrappedValue.title.capitalized,
                                description: viewModel.descriptionTextForChatThread(chatThread: thread.wrappedValue),
                                imageURL: thread.wrappedValue.imageURL,
                                placeholderImage: thread.wrappedValue.type == .sailorServices ? Image("ServiceAvatarImage") : nil,
                                badgeNumber: thread.wrappedValue.unreadCount < 1 ? nil : thread.wrappedValue.unreadCount,
                                auxiliaryText: thread.wrappedValue.lastMessageTime,
                                thumbLetter: thread.wrappedValue.type == .crew ? thread.wrappedValue.title.prefix(1).uppercased() : nil),
                            type: .imageTitleDescriptionBadgeAuxiliary) { id in
                                viewModel.chatThreadCellTapped(id: id)
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchChatThreads()
        }
        .onChange(of: viewModel.hasError) { oldValue, newValue in
            viewHasError = newValue
        }
        .onChange(of: viewModel.isLoading) { oldValue, newValue in
            viewHasError = newValue
        }
        
    }

}


@Observable class MockChatThreadsViewModel: ChatThreadsViewModelProtocol {
    
    var chatThreads: [ChatThread] = []
    var isLoading: Bool = true
    var hasError: Bool = false
    var messengerErrorViewModel: MessengerErrorRetryViewModelProtocol = MockMessengerErrroViewModel()

    init(chatThreads: [ChatThread] = [], isLoading: Bool = false) {
        self.chatThreads = chatThreads
        self.isLoading = isLoading
    }
    
    func fetchChatThreads() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.chatThreads = ChatThread.samples()
        }
    }
	func chatThreadCellTapped(id: String) { }
    
    func descriptionTextForChatThread(chatThread: ChatThread) -> String {        
        "Chat description"
    }
    func tryAgainTapped() {}
}

#Preview {
    ChatThreadsView(viewModel: MockChatThreadsViewModel(), viewHasError: .constant(false), viewIsLoading: .constant(false))
}

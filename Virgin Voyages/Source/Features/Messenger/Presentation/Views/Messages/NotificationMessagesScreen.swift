//
//  NotificationMessagesScreenagessc.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 18.10.24.
//

import SwiftUI

struct NotificationMessagesScreen: View {
    
    @State var viewModel: NotificationMessagesScreenViewModelProtocol
    
    init(viewModel: NotificationMessagesScreenViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .opacity(viewModel.viewOpacity)
            
            // Content
            VStack {
                HStack(alignment: .center) {
                    
//                    Button(action: {
//                        clearAllMessages()
//                    }, label: {
//                        Text("Clear all")
//                    })
//                    .buttonStyle(ClearAllButtonStyle())
                   
                    Spacer()
                    Button(action: {
                        viewModel.dismissView()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30.0))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, Paddings.defaultVerticalPadding24)
                
                if viewModel.messages.isEmpty {
                    // No notifiations label
                    Text("No Notifications")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .fontStyle(.body)
                        .foregroundColor(.white)
                        .padding()
                } else {
                    // Notifications list
                    List {
                        ForEach(viewModel.messages, id: \.id) { message in
                            VVNotificationMessageCard(
                                notificationMessageCard: message,
                                action: {},
                                showLines: false,
                                onVisibilityChange: { visible in
                                    // Updating the notification with delay so that user can see the isRead indicator changing
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                                        Task {
                                            await viewModel.updateVisibility(for: message.id, isVisible: visible)
                                        }
                                    }
                                }
                            )
                            .background(Color.clear)
                            .listRowInsets(EdgeInsets(
                                top: Paddings.defaultVerticalPadding,
                                leading: 0,
                                bottom: Paddings.defaultVerticalPadding,
                                trailing: 0))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.horizontal)
//                            .swipeActions {
//                                Button(role: .destructive) {
//                                    deleteMessage(message)
//                                } label: {
//                                    Label("Delete", systemImage: "trash")
//                                }
//                                .background(Color.clear)
//                            }
                        }
//                        .onDelete(perform: deleteMessages)

                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.top, Paddings.defaultVerticalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(viewModel.viewOpacity)
        }
        .onAppear(perform: viewModel.onAppear)
    }
    
//    private func deleteMessage(_ message: NotificationMessageCardModel) {
//        withAnimation {
//            if let index = messages.firstIndex(where: { $0.id == message.id }) {
//                messages.remove(at: index)
//            }
//        }
//    }
    
//    private func deleteMessages(at offsets: IndexSet) {
//        withAnimation {
//            messages.remove(atOffsets: offsets)
//        }
//    }
    
//    private func clearAllMessages() {
//        withAnimation {
//            // Remove all messages with an animation
//            messages.removeAll()
//        }
//    }
    
}

#Preview {
    let viewModel = MockNotificationMessagesScreenViewModel()
    NotificationMessagesScreen(viewModel: viewModel)
}

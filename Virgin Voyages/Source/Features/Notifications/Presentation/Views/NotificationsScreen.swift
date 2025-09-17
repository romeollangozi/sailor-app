//
//  NotificationsScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 7.4.25.
//

import SwiftUI
import VVUIKit

protocol NotificationsViewModelProtocol {
	var viewOpacity: Double { get }
	var isVisible: Bool { get }
    var isLoading: Bool { get }
    var isFetching: Bool { get }
    var hasMore: Bool { get }
	var appCoordinator: AppCoordinator { get set }
	var notifications: [Notifications.NotificationItem] { get }

    func onAppear()
    func onDisappear()
    func dismissView()
    func showClearAllPopup()
    func handleNotificationTap(item: Notifications.NotificationItem)
    func hasNotificationCenterDestination(item: Notifications.NotificationItem) -> Bool
    func startLoadingMoreNotifications()
}

struct NotificationsScreen: View {
    @State var viewModel: NotificationsViewModelProtocol

    init(viewModel: NotificationsViewModelProtocol = NotificationsViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .opacity(viewModel.viewOpacity)
                .ignoresSafeArea()
			
            if viewModel.isVisible {
                VStack {
					toolbar()
					
                    if viewModel.isLoading {
                        progressView()
                    } else if viewModel.notifications.isEmpty {
						noNotificationsView()
                    } else {
						notficationsListView()
                    }
					
                    Spacer()
                }
                .padding(.top, Paddings.defaultVerticalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .fadeFullScreenCover(item: $viewModel.appCoordinator.homeTabBarCoordinator.notificationsCoordinator.fullScreenOverlayRouter, content: { path in
            switch path {
            case .clearAllPopup:
                ClearAllNotificationsPopupScreen() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        viewModel.dismissView()
                    }
                }
            }
        })
        .onChange(of: viewModel.appCoordinator.homeTabBarCoordinator.notificationsCoordinator.fullScreenOverlayRouter) { oldValue, newValue in
            if newValue == nil {
                viewModel.onAppear()
            }
        }
    }
	
	private func toolbar() -> some View {
		HStack(alignment: .top) {
			Button(action: {
				viewModel.showClearAllPopup()
			}) {
				Text("Clear All")
					.foregroundStyle(Color.black)
					.font(.vvSmallMedium)
					.padding(.horizontal)
					.padding(.vertical, 8)
					.background(Color.white)
					.cornerRadius(1000)
			}
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
		.padding(.bottom, Spacing.space40)
	}
    
    private func progressView() -> some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontStyle(.body)
            .foregroundColor(.white)
    }
	
	private func noNotificationsView() -> some View {
		Text("No Notifications")
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.fontStyle(.body)
			.foregroundColor(.white)
			.padding()
	}
	
    private func notficationsListView() -> some View {
        
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.notifications) { item in
                    let index = viewModel.notifications.firstIndex(where: { $0.id == item.id }) ?? 0
                    
                    NotificationCard(title: item.title,
                                     subtitle: item.description,
                                     timeAgo: item.timeAgo,
                                     isRead: item.isRead,
                                     index: index,
                                     maxHeight: .infinity,
                                     offsetY: 0,
                                     widthFactor: 0.9,
                                     isOnNotificationCenter: true,
                                     hasNotificationCenterDestination: viewModel.hasNotificationCenterDestination(item: item))
                    .animation(.easeInOut(duration: 0.25), value: viewModel.notifications)
                    .onTapGesture {
                        viewModel.handleNotificationTap(item: item)
                    }
                    .padding(.bottom, Spacing.space16)
                    
                }
                
                if viewModel.hasMore {
                    
//                    ProgressView("Loading more...")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .onAppear {
//                            //viewModel.startLoadingMoreNotifications()
//                        }
                    
                    PrimaryButton("Load more", isLoading: viewModel.isFetching) {
                        viewModel.startLoadingMoreNotifications()
                    }
                }
                
            }
            .padding(.horizontal)
        }
        
    }
    
}

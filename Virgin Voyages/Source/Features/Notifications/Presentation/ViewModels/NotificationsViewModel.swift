//
//  NotificationsViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 7.4.25.
//

import SwiftUI

extension NotificationsViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

@Observable
class NotificationsViewModel: BaseViewModel, NotificationsViewModelProtocol {
    private let markAsReadUseCase: MarkNotificationsAsReadUseCaseProtocol
    private let getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol
    private let deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol
	private let getAllNotificationsUseCase: GetAllNotificationsUseCaseProtocol
    
    var appCoordinator: AppCoordinator = .shared

    var viewOpacity: Double
    var isVisible: Bool
    var userApplicationStatus: UserApplicationStatus?
	var notifications: [Notifications.NotificationItem] = []
	
    private var page: Int = 0
    var hasMore = false
    var viewState: ViewState?
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    var notificationsEventsNotificationService: NotificationsEventNotificationService = .shared
    
    init(markAsReadUseCase: MarkNotificationsAsReadUseCaseProtocol = MarkNotificationsAsReadUseCase(),
         getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol = GetUserApplicationStatusUseCase(),
         deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol = DeepLinkNotificationDispatcher(),
		 getAllNotificationsUseCase: GetAllNotificationsUseCaseProtocol = GetAllNotificationsUseCase(),
         viewOpacity: Double = 0.0,
         isVisible: Bool = false) {

        self.markAsReadUseCase = markAsReadUseCase
        self.getUserApplicationStatusUseCase = getUserApplicationStatusUseCase
        self.deepLinkNotificationDispatcher = deepLinkNotificationDispatcher
		self.getAllNotificationsUseCase = getAllNotificationsUseCase
		
        self.viewOpacity = viewOpacity
        self.isVisible = isVisible
    }

	func onAppear() {
		Task {
			await loadNotifications()
		}
		
		withAnimation(.easeOut(duration: 0.5)) {
			viewOpacity = 0.7
			isVisible = true
		}
		
		Task {
			await preloadUserApplicationStatus()
		}
	}
    
    func onDisappear() {
        self.notificationsEventsNotificationService.publish(.shouldUpdateNotificationSection)
    }

	func showClearAllPopup() {
		appCoordinator.executeCommand(NotificationsCoordinator.ShowClearAllNotificationsFullScreenCommand())
	}
    
    func startLoadingMoreNotifications() {
        Task {
            await fetchNextPageOfNotifications()
        }
    }
    
    private func fetchNextPageOfNotifications() async {

		await self.executeOnMain({
			viewState = .fetching
		})
                
        page += 1
        
        if let result = await executeUseCase({
            try await self.getAllNotificationsUseCase.execute(page: self.page)
        }) {
            await executeOnMain {
                self.notifications += result.items
                self.hasMore = result.hasMore
                
                Task { [weak self] in
                    
                    guard let self else { return }
                    await self.markNotificationsAsRead()
                    
                }
                
                self.viewState = .finished
            }
        } else {
            await executeOnMain {
                self.viewState = .finished
            }
        }
    }
    
    private func loadNotifications() async {

		await self.executeOnMain({
			reset()
			viewState = .loading
		})

        if let result = await executeUseCase({
            try await self.getAllNotificationsUseCase.execute(page: self.page)
        }) {
            await executeOnMain {
                
                self.notifications = result.items
                self.hasMore = result.hasMore
                
                Task { [weak self] in
                    
                    guard let self else { return }
                    await self.markNotificationsAsRead()
                    
                }
                
                self.viewState = .finished
            }
        } else {
            await executeOnMain {
                self.viewState = .finished
            }
        }
    }
    
    private func reset() {
        viewState = nil
        notifications.removeAll()
        page = 0
    }
    
    private func markNotificationsAsRead() async {
        let ids = notifications.filter { !$0.isRead }.map { $0.id }
        guard !ids.isEmpty else { return }
        _ = await executeUseCase {
            await self.markAsReadUseCase.execute(notificationIds: ids)
        }
    }

    func dismissView() {
        
        withAnimation(.easeOut(duration: 0.35)) {
            viewOpacity = 0.0
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.appCoordinator.executeCommand(HomeTabBarCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .notifications))
        }
    }
    
	func handleNotificationTap(item: Notifications.NotificationItem) {
        if !item.isTappable {
            return
        }
		
		Task { [weak self] in
			guard let self else { return }
			if let status = userApplicationStatus {
				if self.hasNotificationCenterDestination(item: item) {
					await self.executeOnMain({
						self.dismissView()
						self.deepLinkNotificationDispatcher.dispatch(userStatus: status,
																	 type: item.type,
																	 data: item.data)
					})
				}
			} else {
				// If user is not loaded, wait to load userAppStatus, then Handle notification action again
				await self.preloadUserApplicationStatus()
				self.handleNotificationTap(item: item)
			}
		}
		
	}
    
    func hasNotificationCenterDestination(item: Notifications.NotificationItem) -> Bool {
        let nonTappableTypes: [String] = [
            DeepLinkNotificationType.travelpartyDinningCancelled.rawValue,
            DeepLinkNotificationType.voyagesDinningCancelled.rawValue,
            DeepLinkNotificationType.travelPartyPaidEventCancelled.rawValue,
            DeepLinkNotificationType.travelpartyExcursionCancelled.rawValue,
            DeepLinkNotificationType.voyagesExcursionCancelled.rawValue,
            DeepLinkNotificationType.notificationManagement.rawValue,
            DeepLinkNotificationType.aciActiveboardingroupEmbarkday.rawValue,
            DeepLinkNotificationType.acisupervisorActiveboardingroupEmbarkday.rawValue,
            DeepLinkNotificationType.folioSailorPayer.rawValue,
            DeepLinkNotificationType.folioSailorCash.rawValue
        ]

        return !nonTappableTypes.contains(item.type) && item.isTappable
    }
    
    private func preloadUserApplicationStatus() async {
        do {
            let status = try await getUserApplicationStatusUseCase.execute()
			await self.executeOnMain({
				self.userApplicationStatus = status
			})
        } catch {
            print("Error: \(error)")
        }
    }
}

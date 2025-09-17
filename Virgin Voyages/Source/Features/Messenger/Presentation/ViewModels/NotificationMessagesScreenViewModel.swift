//
//  NotificationMessagesScreenViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 27.11.24.
//

import Foundation
import SwiftUI

protocol NotificationMessagesScreenViewModelProtocol {
    var messages: [NotificationMessageCardModel] { get set }
    var isVisible: Bool { get set }
    var viewOpacity: Double { get set }

    func onAppear()
    func dismissView()

    func updateVisibility(for id: String, isVisible: Bool) async
}

@Observable
class NotificationMessagesScreenViewModel: NotificationMessagesScreenViewModelProtocol {
    private var appCoordinator: CoordinatorProtocol = AppCoordinator.shared
    var markNotificationMessagesAsReadUseCase: MarkNotificationsAsReadUseCaseProtocol

    var messages: [NotificationMessageCardModel]
    var isVisible: Bool
    var viewOpacity: Double

    init() {
        messages = []
        isVisible = false
        viewOpacity = 0.0
        markNotificationMessagesAsReadUseCase = MarkNotificationsAsReadUseCase(repository: NotificationMessagesRepository())
    }

    init(messages: [NotificationMessageCardModel],
         isVisible: Bool,
         viewOpacity: Double = 0.0,
         markNotificationMessagesAsReadUseCase: MarkNotificationsAsReadUseCaseProtocol = MarkNotificationsAsReadUseCase(repository: NotificationMessagesRepository()))
    {
        self.messages = messages
        self.isVisible = isVisible
        self.viewOpacity = viewOpacity
        self.markNotificationMessagesAsReadUseCase = markNotificationMessagesAsReadUseCase
    }

    func dismissView() {
        withAnimation(.easeOut(duration: 0.35)) {
            viewOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.isVisible = false
            self?.appCoordinator.executeCommand(HomeTabBarCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .notifications))
        }
    }

    func onAppear() {
        withAnimation(.easeOut(duration: 0.35)) {
            viewOpacity = 1.0
        }
    }

    func updateVisibility(for id: String, isVisible: Bool) async {
        guard isVisible else { return }
        // Update notification as read if visible at index
        if let index = messages.firstIndex(where: { $0.id == id }) {
            let messageToUpdate = messages[index]
            if !messageToUpdate.isRead {
                let didChange = await markNotificationMessagesAsReadUseCase.execute(notificationIds: [messageToUpdate.id])

                guard didChange else { return }

                messages[index].isRead = true
                messages[index].showReadUnreadIndicator = false
            }
        }
    }
}

@Observable class MockNotificationMessagesScreenViewModel: NotificationMessagesScreenViewModelProtocol {
    var messages: [NotificationMessageCardModel]
    var isVisible: Bool
    var viewOpacity: Double

    let mockItems: [NotificationMessageCardModel] = [
        .init(notificationId: "1", title: "Mock Title", description: "More mock description", notificationsCountText: "1 Notification", readTime: "1 min ago", isRead: true, showReadUnreadIndicator: false, type: .notifications, notificationType: "travelparty.excursion.cancelled", notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}"),
        .init(notificationId: "2", title: "Mock Title", description: "More mock description", notificationsCountText: "1 Notification", readTime: "1 min ago", isRead: false, showReadUnreadIndicator: false, type: .notifications, notificationType: "travelparty.excursion.cancelled", notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}"),
    ]

    init() {
        isVisible = true
        viewOpacity = 1.0
        messages = mockItems
    }

    func onAppear() {}

    func dismissView() {}

    func updateVisibility(for _: String, isVisible _: Bool) async {}
}

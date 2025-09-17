//
//  HomeNotificationsView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.3.25.
//

import SwiftUI
import VVUIKit

struct HomeNotificationView: View {
    @State private var viewModel: HomeNotificationsViewModelProtocol
    
    init(viewModel: HomeNotificationsViewModelProtocol = HomeNotificationsViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            NotificationListView(
                title: viewModel.homeNotifications.title,
                subtitle: viewModel.homeNotifications.summary,
                time: viewModel.homeNotifications.timeAgo,
                numberOfNotifications: viewModel.homeNotifications.unReadCount,
                action: {
                    viewModel.didTapNotifications()
                }
            )
        }.onAppear{
            viewModel.onAppear()
        }
    }
}

#Preview {
    let viewModel = HomeNotificationsViewModel(homeNotifications: HomeNotificationsSection.sample())
    HomeNotificationView(viewModel: viewModel)
}

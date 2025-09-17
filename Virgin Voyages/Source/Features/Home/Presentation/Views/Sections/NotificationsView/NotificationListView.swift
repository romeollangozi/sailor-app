//
//  NotificationListView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.3.25.
//

import SwiftUI
import VVUIKit

struct NotificationListView: View {
    let title: String
    let subtitle: String
    let time: String
    let numberOfNotifications: Int
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.space8) {
            headerView()
            cardView()
        }
        .padding(Spacing.space16)
        .padding(.bottom, Spacing.space24)
    }
    
    private func headerView() -> some View {
        HStack(spacing: Spacing.space4) {
            Text("Notifications")
                .font(.vvHeading4Bold)
            
            Spacer()
            
            if numberOfNotifications > 0 {
                Circle()
                    .fill(Color.vvRed)
                    .frame(width: Spacing.space8, height: Spacing.space8)
            }
            
            if !title.isEmpty && !subtitle.isEmpty {
                Text("\(numberOfNotifications) new")
                    .font(.vvSmall)
                    .foregroundColor(.darkGray)
            }
        }
        .padding(.vertical, Spacing.space8)
    }
    
    private func cardView() -> some View {
        let maxCards = numberOfNotifications >= 3 ? 3 : numberOfNotifications
        if title.isEmpty && subtitle.isEmpty {
            return AnyView(
                StatusBannerView(message: "You're all caught up!")
            )
        } else {
            return AnyView(
                ZStack {
                    ForEach(0..<max(maxCards, 1), id: \.self) { index in
                        NotificationCard(
                            title: title,
                            subtitle: subtitle,
                            timeAgo: time,
                            index: index,
                            offsetY: index == 0 ? 0 : CGFloat(index * 10), // First card stays on top, others shift down
                            widthFactor: index == 0 ? 0.9 : 0.89 - (CGFloat(index) * 0.02), // Decreasing width for lower cards
							lineLimit: 3
                        )
                        .onTapGesture {
                            action()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            )
        }
    }
}

#Preview {
    NotificationListView(
        title: "Someone's booked you a Shore Thing",
        subtitle: "Before you disembark tomorrow, be sure to check your folio in the Sailor App. Questions? Head to...",
        time: "6m ago",
        numberOfNotifications: 3,
        action: {}
    )
}

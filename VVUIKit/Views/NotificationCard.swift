//
//  NotificationCard.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 17.3.25.
//

import SwiftUI

public struct NotificationCard: View {
    let title: String
    let subtitle: String
    let timeAgo: String
    let index: Int
    let minHeight: CGFloat
    let maxHeight: CGFloat // Fixed height for each card
    let offsetY: CGFloat // Dynamic Y-offset based on index
    let widthFactor: CGFloat // Width reduction factor for stacked cards
    let isRead: Bool
    let lineLimit: Int?
    let isOnNotificationCenter: Bool
    let hasNotificationCenterDestination: Bool
    
    public init(title: String,
                subtitle: String,
                timeAgo: String,
                isRead: Bool = true,
                index: Int,
                minHeight: CGFloat = 120,
                maxHeight: CGFloat = 120,
                offsetY: CGFloat,
                widthFactor: CGFloat,
                lineLimit: Int? = nil,
                isOnNotificationCenter: Bool = false,
                hasNotificationCenterDestination: Bool = false) {
        
        self.title = title
        self.subtitle = subtitle
        self.timeAgo = timeAgo
        self.isRead = isRead
        self.index = index
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.offsetY = offsetY
        self.widthFactor = widthFactor
        self.lineLimit = lineLimit
        self.isOnNotificationCenter = isOnNotificationCenter
        self.hasNotificationCenterDestination = hasNotificationCenterDestination
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .offset(y: offsetY)

            VStack(alignment: .leading, spacing: Spacing.space4) {
                HStack(alignment: .top, spacing: Spacing.space16) {
                    Text(title)
                        .font(.vvBodyMedium)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    HStack {
                        Text(timeAgo)
                            .font(.vvSmallMedium)
                            .foregroundColor(Color.slateGray)
                            .frame(alignment: .topTrailing)
                        if !isRead {
                            Circle()
                                .fill(Color.vvRed)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                }

                HStack(spacing: Spacing.space4){
                    
                    Text(subtitle)
                        .font(.vvSmall)
                        .foregroundColor(Color.slateGray)
                        .truncationMode(.tail)
                        .lineLimit(lineLimit)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    if isOnNotificationCenter && hasNotificationCenterDestination {
                        Image(systemName: "chevron.right")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.vvRed)
                            .frame(width: 24, height: 24)
                    }
                    
                }
            }
            .padding()
        }
        .frame(minHeight: minHeight)
        .frame(maxHeight: maxHeight)
        .frame(width: UIScreen.main.bounds.width * widthFactor) // Resize width dynamically
        .zIndex(Double(-index)) // Ensures correct stacking order
    }
}

#Preview {
    NotificationCard(
        title: "Someone's booked you a Shore Thing",
        subtitle: "Before you disembark tomorrow, be sure to check your folio in the Sailor App. Questions? Head to...",
        timeAgo: "5m ago", index: 0, offsetY: 10, widthFactor: 1
    )
}

//
//  StatusBannerView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/29/25.
//

import SwiftUI
import VVUIKit

// MARK: - Status Item (Single Banner)
struct StatusItem: View {
    let title: String
    let message: String
    let isDismissible: Bool
    let onContentClick: () -> Void
    let onDismissClick: () -> Void
    
    init(
        title: String,
        message: String,
        isDismissible: Bool = false,
        onContentClick: @escaping () -> Void = {},
        onDismissClick: @escaping () -> Void = {}
    ) {
        self.title = title
        self.message = message
        self.isDismissible = isDismissible
        self.onContentClick = onContentClick
        self.onDismissClick = onDismissClick
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: Spacing.space0) {
            // Content Column
            VStack(alignment: .leading, spacing: Spacing.space2) {
                Text(title)
                    .font(.vvSmallBold)
                    .foregroundColor(Color.vvWhite)
                    .multilineTextAlignment(.leading)
                
                if !message.isEmpty {
                    Text(message)
                        .font(.vvSmall)
                        .foregroundColor(Color.vvWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                onContentClick()
            }
            .padding(.vertical, Spacing.space16)
            .padding(.leading, Spacing.space24)
            .padding(.trailing, Spacing.space8)
            
            // Dismiss Button
            if isDismissible {
                Button(action: {
                    onDismissClick()
                }) {
                    Image(systemName: "xmark")
                        .font(.vvHeading4Medium)
                        .foregroundColor(Color.darkGray)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.75))
                        .clipShape(Circle())
                }
                .padding(.trailing, Spacing.space16)
            } else {
                Spacer()
                    .frame(width: Spacing.space16)
            }
        }
        .background(Color.deepPurple)
    }
}

// MARK: - Status Banner Content Container
struct StatusBannerContent<Content: View>: View {
    let notificationBanners: [StatusBannersNotifications.StatusBannersNotificationItem]
    let onBannerClick: (StatusBannersNotifications.StatusBannersNotificationItem) -> Void
    let onDismissClick: (String) -> Void
    let content: Content
    
    @State private var isExpanded: Bool = false
    @State private var expandedContentHeight: CGFloat = 0
    
    init(
        notificationBanners: [StatusBannersNotifications.StatusBannersNotificationItem],
        onBannerClick: @escaping (StatusBannersNotifications.StatusBannersNotificationItem) -> Void = { _ in },
        onDismissClick: @escaping (String) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.notificationBanners = notificationBanners
        self.onBannerClick = onBannerClick
        self.onDismissClick = onDismissClick
        self.content = content()
    }
    
    var body: some View {
        if notificationBanners.isEmpty {
            content
        } else {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    // Main Content (always full screen)
                    VStack(spacing: Spacing.space0) {
                        // Spacer to push content below the banner header
                        Rectangle()
                            .fill(Color.deepPurple)
                            .frame(height: bannerHeaderHeight)
                        
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    // Banner Section (overlays on top)
                    VStack(spacing: Spacing.space0) {
                        // Main banner header
                        bannerHeaderContent
                        
                        // Expanded banners (overlay on top of content)
                        if isExpanded && notificationBanners.count > 1 {
                            expandedBannersContent(availableHeight: geometry.size.height)
                        }
                    }
                    .background(Color.deepPurple)
                    .zIndex(1) // Ensure banners are on top
                }
            }
        }
    }
    
    private var bannerHeaderHeight: CGFloat {
        return 56 // Approximate height of a single banner
    }
    
    @ViewBuilder
    private var bannerHeaderContent: some View {
        if notificationBanners.count == 1 {
            // Single banner
            StatusItem(
                title: notificationBanners.first!.title,
                message: notificationBanners.first!.description,
                isDismissible: notificationBanners.first!.isDismissable,
                onContentClick: {
                    onBannerClick(notificationBanners.first!)
                },
                onDismissClick: {
                    onDismissClick(notificationBanners.first!.id)
                }
            )
        } else {
            // Multiple banners header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: Spacing.space16) {
                    Text("You have \(notificationBanners.count) services pending")
                        .font(.vvSmallBold)
                        .foregroundColor(Color.vvWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .frame(width: 32, height: 32)
                        .font(.vvSmallMedium)
                        .foregroundColor(Color.vvWhite)
                }
                .padding(.horizontal, Spacing.space24)
                .padding(.vertical, Spacing.space16)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder
    private func expandedBannersContent(availableHeight: CGFloat) -> some View {
        let maxAllowedHeight = availableHeight - bannerHeaderHeight
        
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 0) {
                ForEach(Array(notificationBanners.enumerated()), id: \.element.id) { index, banner in
                    VStack(spacing: 0) {
                        StatusItem(
                            title: banner.title,
                            message: banner.description,
                            isDismissible: banner.isDismissable,
                            onContentClick: {
                                onBannerClick(banner)
                            },
                            onDismissClick: {
                                onDismissClick(banner.id)
                            }
                        )
                        
                        // Divider (except for last item)
                        if index < notificationBanners.count - 1 {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 1)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                        }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .background(
                GeometryReader { contentGeometry in
                    Color.clear
                        .onAppear {
                            expandedContentHeight = contentGeometry.size.height
                        }
                        .onChange(of: notificationBanners.count) { _, _ in
                            DispatchQueue.main.async {
                                expandedContentHeight = contentGeometry.size.height
                            }
                        }
                }
            )
        }
        .frame(maxHeight: min(expandedContentHeight > 0 ? expandedContentHeight : CGFloat(notificationBanners.count * 60), maxAllowedHeight))
        .background(Color.deepPurple)
        .animation(.easeInOut(duration: 0.3), value: notificationBanners.count)
    }
}

// MARK: - Preview Models and Examples
struct MockView: View {
    var body: some View {
        Text("Main App Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.orange))
    }
}

// MARK: - Previews
#Preview("Single Banner - No Dismiss") {
    StatusBannerContent(
        notificationBanners: [
            StatusBannersNotifications.StatusBannersNotificationItem(
                id: "75e15287-e544-44cf-87ca-cc0ca17bb78b",
                type: "notification.management",
                data: "{}",
                title: "Free form notification for Sailor 05/01/2025",
                description: "Free form notification for Sailor 05/01/2025.",
                isRead: false,
                createdAt: Date(),
                isTappable: true,
                isDismissable: false
            )
        ],
        onBannerClick: { banner in
            print("Clicked banner: \(banner.title)")
        },
        onDismissClick: { notificationId in
            print("Dismissed banner: \(notificationId)")
        }
    ) {
        MockView()
    }
}

#Preview("Single Banner - Dismissible") {
    SingleBannerDismissiblePreview()
}

struct SingleBannerDismissiblePreview: View {
    @State private var banners: [StatusBannersNotifications.StatusBannersNotificationItem] = [
        StatusBannersNotifications.StatusBannersNotificationItem(
            id: "75e15287-e544-44cf-87ca-cc0ca17bb78b",
            type: "notification.management",
            data: "{}",
            title: "Free form notification for Sailor 05/01/2025",
            description: "Free form notification for Sailor 05/01/2025.",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: true
        )
    ]
    
    var body: some View {
        StatusBannerContent(
            notificationBanners: banners,
            onBannerClick: { banner in
                print("Clicked banner: \(banner.title)")
            },
            onDismissClick: { notificationId in
                withAnimation(.easeInOut(duration: 0.3)) {
                    banners.removeAll { $0.id == notificationId }
                }
            }
        ) {
            MockView()
        }
    }
}

#Preview("Multiple Banners - Interactive") {
    MultipleBannersInteractivePreview()
}

struct MultipleBannersInteractivePreview: View {
    @State private var banners: [StatusBannersNotifications.StatusBannersNotificationItem] = [
        StatusBannersNotifications.StatusBannersNotificationItem(
            id: "banner-1",
            type: "notification.management",
            data: "{}",
            title: "Your Champagne order is on the way.",
            description: "Sorry it's going to be 5 mins longer",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: false
        ),
        StatusBannersNotifications.StatusBannersNotificationItem(
            id: "banner-2",
            type: "notification.management",
            data: "{}",
            title: "Your Champagne order has been cancelled.",
            description: "Shake again sometime",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: true
        ),
        StatusBannersNotifications.StatusBannersNotificationItem(
            id: "banner-3",
            type: "notification.management",
            data: "{}",
            title: "Room service is ready",
            description: "Your order has been delivered to your stateroom",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: true
        ),
        StatusBannersNotifications.StatusBannersNotificationItem(
            id: "banner-4",
            type: "notification.management",
            data: "{}",
            title: "Dinner reservation confirmed",
            description: "Table for 2 at The Wake restaurant at 7:30 PM",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: false
        ),
        StatusBannersNotifications.StatusBannersNotificationItem(
            id: "banner-5",
            type: "notification.management",
            data: "{}",
            title: "Spa appointment reminder",
            description: "Your massage appointment is in 30 minutes",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: true
        )
    ]
    
    var body: some View {
        StatusBannerContent(
            notificationBanners: banners,
            onBannerClick: { banner in
                print("Clicked banner: \(banner.title)")
            },
            onDismissClick: { notificationId in
                withAnimation(.easeInOut(duration: 0.3)) {
                    banners.removeAll { $0.id == notificationId }
                }
            }
        ) {
            MockView()
        }
    }
}

// MARK: - Preview for Testing Scrollable Behavior
#Preview("Many Banners - Scrollable Test") {
    ManyBannersScrollablePreview()
}

struct ManyBannersScrollablePreview: View {
    @State private var banners: [StatusBannersNotifications.StatusBannersNotificationItem] = {
        var testBanners: [StatusBannersNotifications.StatusBannersNotificationItem] = []
        for i in 1...10 {
            testBanners.append(
                StatusBannersNotifications.StatusBannersNotificationItem(
                    id: "banner-\(i)",
                    type: "notification.management",
                    data: "{}",
                    title: "Banner \(i) Title",
                    description: "This is the description for banner number \(i). It contains some sample text to test the scrolling behavior.",
                    isRead: false,
                    createdAt: Date(),
                    isTappable: true,
                    isDismissable: i % 2 == 0
                )
            )
        }
        return testBanners
    }()
    
    var body: some View {
        StatusBannerContent(
            notificationBanners: banners,
            onBannerClick: { banner in
                print("Clicked banner: \(banner.title)")
            },
            onDismissClick: { notificationId in
                withAnimation(.easeInOut(duration: 0.3)) {
                    banners.removeAll { $0.id == notificationId }
                }
            }
        ) {
            MockView()
        }
    }
}

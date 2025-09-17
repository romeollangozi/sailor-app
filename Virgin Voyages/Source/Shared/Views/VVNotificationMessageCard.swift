//
//  VVCardWithBottomLines.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 21.10.24.
//

import SwiftUI

struct VVNotificationMessageCard: View {
    let notificationMessageCard: NotificationMessageCardModel
    var isLoading: Bool
    let action: () -> Void
    var onVisibilityChange: ((Bool) -> Void)?
    
    @State private var isFullyVisible: Bool = false
    @State var showLines: Bool
    
    init(notificationMessageCard: NotificationMessageCardModel,
         isLoading: Bool = false,
         action: @escaping () -> Void,
         showLines: Bool = true,
         onVisibilityChange: ((Bool) -> Void)? = nil
    ) {
        self.notificationMessageCard = notificationMessageCard
        self.action = action
        self.showLines = showLines
        self.onVisibilityChange = onVisibilityChange
        self.isLoading = isLoading
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding) {
                    
                    HStack (alignment: .center) {
                        // Title
                        Text(notificationMessageCard.title)
                            .font(.custom(FontStyle.boldTagline.fontName, size: FontStyle.body.pointSize)) // 16 medium
                            .foregroundColor(.black)
                        Spacer()
                        
                        if isLoading {
                            // Small spinner to indicate refreshing/updating
                            ProgressView()
                                .padding(.zero)
                                .scaleEffect(0.70)
                        }
                    }
                    
                    // Description
                    Text(notificationMessageCard.description)
                        .fontStyle(.smallBody) // 14 regular
                        .foregroundColor(.gray)
                        .lineLimit(.max)
                    
                    // Bottom row with Read/Unread indicator and receivedAt label
                    HStack {
                        if notificationMessageCard.showReadUnreadIndicator {
                            // Read/Unread Indicator
                            Circle()
                                .fill(notificationMessageCard.isRead ? Color.gray : Color.selectedGreen)
                                .frame(width: 10, height: 10)
                        }
                        
                        // Read/Unread text indicator
                        Text(notificationMessageCard.notificationsCountText)
                            .fontStyle(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        // Received at
                        Text(notificationMessageCard.readTime)
                            .fontStyle(.caption) // 14 medium
                            .foregroundColor(.gray)
                    }
                    .padding(.top, Paddings.defaultVerticalPadding16)
                }
                .padding(.top)
                .padding(.horizontal)

                if showLines {
                    BottomLinesView(numberOfLines: 3)
                        .padding(.bottom, Paddings.smallVerticalPadding3)
                        .padding(.top, Paddings.defaultVerticalPadding)
                } else {
                    HStack{}.frame(height: 10.0)
                }
            }
            .multilineTextAlignment(.leading)
            .background(.white)
            .clipShape(RoundedCorner(radius: CornerRadiusValues.defaultCornerRadius, corners: showLines ? [.topLeft, .topRight] : [.allCorners]))
            .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 0)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: isFullyVisible) { _, newValue in
                            onVisibilityChange?(newValue)
                        }
                        .onAppear {
                            calculateVisibility(geometry: geometry)
                        }
                        .onChange(of: geometry.frame(in: .global)) { _, _ in
                            calculateVisibility(geometry: geometry)
                        }
                }
            )
        }
    }
    
    private func calculateVisibility(geometry: GeometryProxy) {
        // Get the frame of the card relative to the screen (global coordinates)
        let frame = geometry.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        
        // Check if the card is fully visible within the screen
        let fullyVisible = frame.minY >= 0 && frame.maxY <= screenHeight
        if fullyVisible != isFullyVisible {
            isFullyVisible = fullyVisible
        }
    }

}


extension VVNotificationMessageCard {
    struct BottomLinesView: View {
        var numberOfLines: Int = 0
        var lineColor: Color = .gray
        var lineThickness: CGFloat = 1.0
        var lineOpacity: Double = 0.3
        
        var body: some View {
            VStack(spacing: Paddings.smallVerticalPadding3) {
                ForEach(0..<numberOfLines, id: \.self) { _ in
                    Rectangle()
                        .fill(lineColor)
                        .frame(height: lineThickness)
                }
            }
            .opacity(lineOpacity)
        }
    }
}

#Preview {
    VStack(spacing: Paddings.defaultVerticalPadding) {
        let previewItem = NotificationMessageCardModel(notificationId: "1", title: "Title", description: "Description", notificationsCountText: "2 Unread notifications", readTime: "2 hours ago", isRead: false, showReadUnreadIndicator: true, type: .undefined, notificationType: "travelparty.excursion.cancelled", notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}" )
        VVNotificationMessageCard(notificationMessageCard: previewItem, action: {}, onVisibilityChange: { _ in })
        
    }.padding()
}

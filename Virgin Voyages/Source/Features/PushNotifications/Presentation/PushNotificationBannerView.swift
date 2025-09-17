//
//  PushNotificationBannerView.swift
//  Virgin Voyages
//
//  Created by TX on 13.11.24.
//

import SwiftUI

struct PushNotificationBannerView: View {
    var pushNotification: PushNotificationModel?
    @Binding var showNotification: Bool
    
    var didAppear: (() -> Void)?
    var onTap: (() -> Void)?
        
    var body: some View {
        VStack {
            if showNotification, let pushNotification {
                GeometryReader { geometry in
                    
                    Button(action: {
                        handleTap()
                    }) {
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(pushNotification.title)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text(pushNotification.message)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, Paddings.defaultHorizontalPadding)
                    .padding(.vertical)
                    .background(Color.squidInk)
                    .cornerRadius(CornerRadiusValues.defaultCornerRadius)
                    .shadow(radius: 5)
                    .frame(width: geometry.size.width)
                    .onAppear {
                        didAppear?()
                        autoDismiss()
                    }
                    
                }
                .transition(.move(edge: .top))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Paddings.defaultVerticalPadding16)
        .padding(.horizontal)
        .animation(.easeInOut(duration: 1), value: showNotification)
    }
    
    private func handleTap() {
        onTap?()
        dismissBanner()
    }
    
    private func dismissBanner() {
        withAnimation {
            showNotification = false
        }
    }
    
    private func autoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            dismissBanner()
        }
    }
}

#Preview {
    struct PushNotificationPreviewWrapper: View {
        @State private var showNotification = false
        let pushNotification = PushNotificationModel(title: "Message Title",
                                                     message: "Message Body",
                                                     notificationType: "",
                                                     notificationData: "")
        
        var body: some View {
            VStack {
                PushNotificationBannerView(pushNotification: pushNotification, showNotification: $showNotification, onTap:  {
                    
                })
            }
            .onAppear {
                // Trigger the banner to show after a short delay, then hide it
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showNotification = true
                }
            }
        }
    }
    
    return PushNotificationPreviewWrapper()
}

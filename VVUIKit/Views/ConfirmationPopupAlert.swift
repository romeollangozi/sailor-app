//
//  ConfirmationPopupAlert.swift
//  VVUIKit
//
//  Created by TX on 11.2.25.
//

import SwiftUI

public struct ConfirmationPopupAlert: View {
    
    public enum ButtonStyleType {
        case primary
        case secondary
    }
        
    var title: String
    var message: String
    var confirmButtonText: String
    var confirmButtonStyle: ButtonStyleType
    var cancelButtonText: String
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    @Binding var isLoading: Bool
    @State private var showOverlay = false
    @State private var showPopup = false

    
    public init(title: String, message: String, confirmButtonText: String, confirmButtonStyle: ButtonStyleType = .secondary, cancelButtonText: String, isLoading: Binding<Bool>, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.confirmButtonText = confirmButtonText
        self.confirmButtonStyle = confirmButtonStyle
        self.cancelButtonText = cancelButtonText
        self._isLoading = isLoading
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(showOverlay ? 0.5 : 0.0)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.2), value: showOverlay)
            
            if showPopup {
                VStack() {
                    VStack {
                        HStack {
                            Spacer()
                            XClosableButton(action: onCancel)
                        }
                        .padding(.top, Spacing.space24)
                        .padding(.bottom, Spacing.space16)
                        
                        Text(title)
                            .font(.vvHeading3Bold)
                            .padding(.bottom, Spacing.space8)
                        
                        Text(message)
                            .font(.vvSmall)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                    }
                    .padding(.horizontal, Spacing.space24)
                    .padding(.bottom, Spacing.space16)
                    
                    
                    VStack(spacing: 0.0) {
                        if confirmButtonStyle == .primary{
                            PrimaryButton(confirmButtonText, font: .vvBody, isLoading: isLoading, action: onConfirm)
                        }else{
                            SecondaryButton(confirmButtonText, isLoading: isLoading, action:onConfirm, font: .vvBody)
                        }
                        
                        LinkButton(cancelButtonText, font: .vvBody, action: onCancel)
                            .padding(.bottom, Spacing.space32)
                    }
                    .padding(.horizontal, Spacing.space8)
                }
                .background(Color.white)
                .cornerRadius(Spacing.space12)
                .padding(.horizontal, Spacing.space24)
                .transition(.opacity)
                .animation(.easeIn, value: showPopup)
            }
        }
        .onAppear {
            showOverlay = true
            withAnimation(.easeInOut(duration: 0.1).delay(0.15)) {
                showPopup = true
            }
        }
        .onDisappear {
            showOverlay = false
            showPopup = false
        }

    }
}


#Preview("Confirmation Popup Alert") {
    ConfirmationPopupAlert(
        title: "Confirm action",
        message: "Are you sure you want to delete this contact? you won’t be able to book activities with them.",
        confirmButtonText: "Yes, delete contact",
        cancelButtonText: "Cancel",
        isLoading: .constant(false)
    ) {
        
    } onCancel: {
        
    }
}

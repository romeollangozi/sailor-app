//
//  UncancellableAlertModifier.swift
//  Virgin Voyages
//
//  Created by TX on 23.5.25.
//

import SwiftUI

struct UncancellableAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let buttonText: String
    let action: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented) // block background interaction
                .blur(radius: isPresented ? 2 : 0)

            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 16) {
                    Text(title)
                        .font(.body)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    Divider()

                    Button(buttonText) {
                        action()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 20)
                .padding(.horizontal, 40)
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func uncancellableAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        buttonText: String = "OK",
        action: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(UncancellableAlertModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            buttonText: buttonText,
            action: action
        ))
    }
}

//
//  BackButton.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import SwiftUI

struct VVBackButton: View {
    @Environment(\.dismiss) private var dismiss
    var color: Color = .vvDarkGray
    
    let onDismiss: (() -> Void)?
    
    init(buttonColor: Color = .vvGray, onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        self.color = buttonColor
    }
    
    var body: some View {
        Button(action: {
            // Dismiss the current view
            (onDismiss ?? dismissView)()
        }) {
            Image(systemName: "arrow.backward.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .foregroundStyle(color, .clear)

    }
    
    private func dismissView() {
        dismiss()
    }
}

#Preview {
    VVBackButton()
        .background(
            Color.red
        )
}

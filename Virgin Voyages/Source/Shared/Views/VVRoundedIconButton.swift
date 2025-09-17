//
//  VVRoundedIconButton.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 21.10.24.
//

import SwiftUI

struct VVRoundedIconButton: View {
    
    let backgroundColor: Color
    let foregroundColor: Color
    let text: String
    let icon: String
    let action: () -> Void
    
    init(backgroundColor: Color = .white,
         foregroundColor: Color = .accentColor,
         text: String,
         icon: String,
         action: @escaping () -> Void) {
        
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.text = text
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Paddings.defaultVerticalPadding) {
                Image(systemName: icon)
                Text(text)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryMessengerButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        VVRoundedIconButton(text: "Connections", icon: "qrcode") {
            print("Button tapped")
        }
        .padding()
    }.background(.gray)
}

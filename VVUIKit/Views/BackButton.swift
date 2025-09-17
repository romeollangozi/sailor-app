//
//  BackButton.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.1.25.
//

import SwiftUI

public struct BackButton: View {
    
    private let action: () -> Void
    private let isCircleButton: Bool
    private let buttonIconName: String
    
    public init (_ action: @escaping () -> Void,
                 isCircleButton: Bool = true,
                 buttonIconName: String = "arrow.backward.circle.fill") {
        
        self.action = action
        self.isCircleButton = isCircleButton
        self.buttonIconName = buttonIconName
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: buttonIconName)
                .resizable()
                .frame(width: 30, height: 30)
        }
        .foregroundStyle(.black, .clear)
        .background(
            isCircleButton ? AnyView(Circle().fill(Color.white)) : AnyView(Color.clear)
        )
    }
}

#Preview("Back Button") {
    VStack {
        BackButton({ print("Back Button tapped")}, isCircleButton: true)
    }.background(.purple)
}

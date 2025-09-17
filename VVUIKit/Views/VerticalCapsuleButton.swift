//
//  VerticalCapsuleButton.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 22.1.25.
//

import SwiftUI

public struct VerticalCapsuleButton: View {
    
    // MARK: - Properties
    let imageName: String
    let title: String
    let action: () -> Void
    
    // MARK: - Button Constants
    let buttonWidth: CGFloat = 100.0
    let buttonHeight: CGFloat = 140.0
    let buttonRoundCornerRadius: CGFloat = 40.0
    
    // MARK: - Init
    public init(imageName: String, title: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: Spacing.space8) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Spacing.space32, height: Spacing.space32)
                
                Text(title)
                    .font(.vvSmallMedium)
                    .multilineTextAlignment(.center)
                    .lineLimit(3, reservesSpace: true)
                    .foregroundColor(.blackText)
            }
            .padding()
            .padding(.top, Spacing.space8)
            .frame(width: buttonWidth, height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: buttonRoundCornerRadius)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())

    }
}


struct VerticalCapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            VerticalCapsuleButton(imageName: "QrCode", title: "Example Title") {
                print("Button tapped!")
            }
            .previewLayout(.sizeThatFits)

            VerticalCapsuleButton(imageName: "FindFreind", title: "Another Title") {
                print("Another button tapped!")
            }
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
        .padding()
    }
}

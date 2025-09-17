//
//  CircleButton.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

import SwiftUI

public struct PrimaryCircleButton: View {
    let action: () -> Void

    public init(_ action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        CircleButton(color: .vvRed, action: action)
    }
}

private struct CircleButton: View {
    let action: () -> Void
    let color: Color
    
    init(color: Color, action: @escaping () -> Void) {
        self.action = action
        self.color = color
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.right")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
                .frame(width: 60, height: 60)
                .background(color)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

public struct CircleImageButton: View {
	let action: () -> Void
	let color: Color
	let imageName: String
	let size: CGSize
	let imagePadding: CGFloat
    

    public init(color: Color, imageName: String, size: CGSize = CGSize(width: Spacing.space64, height: Spacing.space64), imagePadding: CGFloat = Spacing.space8, action: @escaping () -> Void) {
        
		self.action = action
		self.color = color
		self.imageName = imageName
		self.size = size
		self.imagePadding = imagePadding
	}

	public var body: some View {
		Button(action: action) {
			ZStack {
				Circle()
					.fill(color)
					.frame(width: size.width, height: size.height)

				Image(imageName)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: size.width * 0.5, height: size.height * 0.5)
					.padding(imagePadding)
			}
		}
		.frame(width: size.width, height: size.height)
		.clipShape(Circle())
	}
}



#Preview("Circle Buttons") {
    PrimaryCircleButton({})
	CircleImageButton(color: .rockstarDark, imageName: "Messenger", size: CGSize(width: 36, height: 36), action: {})
    
    CircleImageButton(color: .black.opacity(0.5), imageName: "chatBubbleIcon") {}
}

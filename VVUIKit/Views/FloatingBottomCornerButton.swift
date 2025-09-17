//
//  FloatingBottomCornerButton.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 3.9.25.
//

import SwiftUI

public struct FloatingBottomCornerButton: View {
    public let icon: String
    public let action: () -> Void

    public static let size: CGFloat = 64
    public static let trailingPadding: CGFloat = 24
    public static let bottomPadding: CGFloat = 24
    public static let extraSafeAreaPadding: CGFloat = 83
    public static let imageSize: CGFloat = 14

    public init(icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        GeometryReader { geo in
            let position = CGPoint(
                x: geo.size.width - Self.size / 2 - Self.trailingPadding,
                y: geo.size.height - Self.size / 2 - Self.bottomPadding - Self.extraSafeAreaPadding
            )

            Button(action: action) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Self.imageSize, height: Self.imageSize)
                    .foregroundStyle(Color.white)
                    .frame(width: Self.size, height: Self.size)
                    .background(Circle().fill(Color.vvRed))
            }
            .frame(width: Self.size, height: Self.size)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.20), radius: 50, x: 0, y: 0)
            .position(position)
        }
        .ignoresSafeArea()
    }
}

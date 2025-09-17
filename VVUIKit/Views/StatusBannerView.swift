//
//  StatusBannerView.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 18.4.25.
//

import SwiftUI

public struct StatusBannerView: View {
    // MARK: - Public Properties
    public let message: String
    public let imageName: String
    public let backgroundColor: Color
    public let borderColor: Color

    // MARK: - Init
    public init(
        message: String,
        imageName: String = "CheckCircle",
        backgroundColor: Color = Color.softGray,
        borderColor: Color = Color.borderGray
    ) {
        self.message = message
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
    }

    // MARK: - View
    public var body: some View {
        VStack {
            HStack(spacing: Spacing.space4) {
                Image(imageName)
                Text(message)
                    .font(.vvSmall)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.space10)
            .padding(.horizontal, Spacing.space32)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .background(backgroundColor)
        .padding(.vertical, Spacing.space16)
    }
}

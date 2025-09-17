//
//  CarouselCardView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 17.3.25.
//

import SwiftUI
import VVUIKit

struct CarouselCardView: View {
    let title: String
    let imageURL: String
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    init(title: String, imageURL: String, color: Color, width: CGFloat = 340, height: CGFloat = 115, action: @escaping () -> Void) {
        self.title = title
        self.imageURL = imageURL
        self.color = color
        self.width = width
        self.height = height
        self.action = action
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: CornerRadiusValues.defaultCornerRadius)
                .fill(color)
                .overlay(
                    HStack(spacing: Spacing.space16) {
                        ImageViewer(url: imageURL)
                            .frame(width: Sizes.defaultSize80, height: Sizes.defaultSize80)
                        
                        Text(title)
                            .font(.vvBodyBold)
                            .foregroundColor(Color.blackText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                        .padding(.horizontal, Spacing.space24)
                        .padding(.vertical, Spacing.space16)
                )
                .frame(width: width, height: height)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }.onTapGesture {
            action()
        }
    }
}

#Preview {
    CarouselCardView(
        title: "Buy $300 Bar Tab and get a bonus on us.",
        imageURL: "https://example.com/muster.jpg",
        color: .gray,
        action: {})
}

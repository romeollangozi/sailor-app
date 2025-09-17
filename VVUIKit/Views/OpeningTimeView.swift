//
//  OpeningTimeView.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 9.4.25.
//

import SwiftUI

public struct OpeningTimeView: View {
    // MARK: - Properties
    public let imageURL: String
    public var title: String
    public let subtitle: String
    public let buttonTitle: String
    public let buttonAction: (() -> Void)?

    // MARK: - Init
    public init(
        imageURL: String,
        title: String,
        subtitle: String,
        buttonTitle: String = "",
        buttonAction: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    // MARK: - Body
    public var body: some View {
        VStack(spacing: 16) {
            if let url = URL(string: imageURL) {
                URLImage(url: url)
                    .frame(width: 180, height: 180)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding(.bottom, Spacing.space32)
            }
            Text(title)
                .font(.vvHeading3Bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, Spacing.space16)

            Text(subtitle)
                .font(.vvHeading5)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.slateGray)
                .padding(.horizontal, Spacing.space40)

            if let action = buttonAction {
                Button(action: action) {
                    HStack {
                        Image("Calendar")
                        Text(buttonTitle)
                            .underline()
                            .font(.vvBodyMedium)
                            .foregroundStyle(Color.darkGray)
                    }
                }
                .padding(.top, Spacing.space48)
                .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.sheetBackgroundColor)
    }
}

// MARK: - Preview

struct OpeningTimeView_Previews: PreviewProvider {
    static var previews: some View {
            OpeningTimeView(
                imageURL: "https://via.placeholder.com/150",
                title: "Spa Treatment booking opens at 12am EST  February 10 2024",
                subtitle: "Pop back by then to book your shipboard treatments.",
                buttonTitle: "Add to my calendar",
                buttonAction: {
                    print("Add to my calendar")
                }
            )
    }
}

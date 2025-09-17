//
//  InfoDrawerView.swift
//  VVUIKit
//
//  Created by Pajtim on 29.7.25.
//

import SwiftUI

public struct InfoDrawerView<PrimaryStyle: ButtonStyle>: View {
    let title: String
    let description: String
    let buttonTitle: String?
    let buttonStyle: PrimaryStyle
    let isSpaceOnBottom: Bool
    let action: () -> Void

    public init(
        title: String,
        description: String,
        buttonTitle: String? = nil,
        buttonStyle: PrimaryStyle,
        isSpaceOnBottom: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonStyle = buttonStyle
        self.isSpaceOnBottom = isSpaceOnBottom
        self.action = action
    }

    public var body: some View {
            VStack(alignment: .leading) {
                toolbar()

                VStack(alignment: .leading, spacing: Spacing.space24) {

                    Text(title)
                        .font(.vvHeading3Bold)
                        .multilineTextAlignment(.leading)

                    HTMLText(htmlString: description, fontType: .normal, fontSize: .size14, color: Color.slateGray)

                    if let buttonTitle {
                        Button(buttonTitle) {
                            action()
                        }
                        .buttonStyle(buttonStyle)
                        .padding(.bottom, isSpaceOnBottom ? Spacing.space64 : 0)
                    }
                }
                .padding(.horizontal, Spacing.space24)
                Spacer()
        }
    }

    func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            action()
        }
    }
}

public extension InfoDrawerView where PrimaryStyle == SecondaryButtonStyle {
    init(
        title: String,
        description: String,
        buttonTitle: String? = nil,
        isSpaceOnBottom: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            description: description,
            buttonTitle: buttonTitle,
            buttonStyle: SecondaryButtonStyle(),
            isSpaceOnBottom: isSpaceOnBottom,
            action: action
        )
    }
}

#Preview {
    InfoDrawerView(title: "Title", description: "Description", buttonTitle: "Got it", action: {})
}

public struct SecondaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(15)
            .font(.vvBodyMedium)
            .background(configuration.isPressed ? Color.gray : Color.white)
            .foregroundStyle(configuration.isPressed ? .white: Color(uiColor: .darkGray))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundStyle(.gray)
            }
    }
}

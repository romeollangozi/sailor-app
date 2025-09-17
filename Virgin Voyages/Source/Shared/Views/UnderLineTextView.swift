//
//  UnderLineView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

import SwiftUI

public struct UnderLineTextView: View {

	private let text: String
	private let fontSize: CGFloat = Constants.fontSize
	private let lineSpacing: CGFloat = Constants.lineSpacing
	private let lineHeight: CGFloat = Constants.lineHeight
	private let padding: CGFloat = Constants.padding
	private var textColor: Color
	private var underLineColor: Color

	public init(text: String, textColor: Color = .white, underLineColor: Color = .secondaryRockstar) {
		self.text = text
		self.textColor = textColor
		self.underLineColor = underLineColor
	}

	public var body: some View {
		VStack(spacing: lineSpacing) {
			let lines = text.splitLines(maxLineWidth: UIScreen.main.bounds.width - 2 * padding, fontSize: fontSize)

			ForEach(0..<lines.count, id: \.self) { index in
				ZStack {
					let textWidth = lines[index].widthOfString(usingFont: UIFont.systemFont(ofSize: fontSize))

					VStack(spacing: 2) {
						Rectangle()
							.frame(width: textWidth + 20, height: lineHeight)
							.foregroundColor(underLineColor)
						Rectangle()
							.frame(width: textWidth + 20, height: lineHeight)
							.foregroundColor(underLineColor)
					}

					Text(lines[index])
						.font(.vvHeading1Bold)
						.foregroundColor(textColor)
						.padding(.top, -24)
				}
			}
		}
		.padding(.horizontal, padding)
		.frame(maxWidth: .infinity)
	}
}

struct Constants {
	static let fontSize: CGFloat = 40
	static let lineSpacing: CGFloat = 10
	static let lineHeight: CGFloat = 3
	static let padding: CGFloat = 64
}

struct UnderLineTextViewPreview: View {
	var body: some View {
		VStack {
			ScrollView {
				UnderLineTextView(
					text: "You’re a Rockstar"
				)
				.padding(48)

				UnderLineTextView(
					text: "You’re a Mega Rockstar"
				)
				.padding(48)

				UnderLineTextView(
					text: "Simple multiline text that goes over multiple lines and is underlined"
				)
				.padding(48)
			}
		}
		.background(Color.rockstarGray)
	}
}

#Preview {
	UnderLineTextViewPreview()
}

//
//  BoldedTextView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.3.25.
//

import SwiftUI

public struct BoldedTextView: View {
	let text: String
	let placeholders: [String]
	let textColor: Color
	let defaultFont: Font
	let alignment: TextAlignment

	public init(
		text: String,
		placeholders: [String],
		textColor: Color = .black,
		defaultFont: Font = .vvBody,
		alignment: TextAlignment = .leading
	) {
		self.text = text
		self.placeholders = placeholders
		self.textColor = textColor
		self.defaultFont = defaultFont
		self.alignment = alignment
	}

	public var body: some View {
		formattedText()
			.foregroundColor(textColor)
			.multilineTextAlignment(alignment)
	}

	private func formattedText() -> Text {
		var result = Text("")
		var lastIndex = text.startIndex

		while let (range, placeholder) = findNextPlaceholder(in: text, from: lastIndex) {
			let beforeText = String(text[lastIndex..<range.lowerBound])
			result = result + Text(beforeText).font(defaultFont)
			result = result + Text(placeholder).font(defaultFont).bold()
			lastIndex = range.upperBound
		}

		let remainingPart = String(text[lastIndex...])
		result = result + Text(remainingPart).font(defaultFont)

		return result
	}

	private func findNextPlaceholder(in text: String, from startIndex: String.Index) -> (Range<String.Index>, String)? {
		var firstFound: (Range<String.Index>, String)? = nil

		for placeholder in placeholders {
			if let range = text.range(of: placeholder, range: startIndex..<text.endIndex) {
				if firstFound == nil || range.lowerBound < firstFound!.0.lowerBound {
					firstFound = (range, placeholder)
				}
			}
		}

		return firstFound
	}
}

// MARK: - Preview
struct BoldedTextView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			VStack(spacing: 16) {
				Text("Default Font + Left Aligned")
					.font(.caption)
					.foregroundColor(.gray)

				BoldedTextView(
					text: "Welcome aboard Virgin Voyages, dear Guest!",
					placeholders: ["Virgin Voyages", "Guest"],
					textColor: .black,
					defaultFont: .vvBody,
					alignment: .leading
				)
			}
			.padding()
			.previewDisplayName("Left Aligned")

			VStack(spacing: 16) {
				Text("Tiny Font + Center Aligned")
					.font(.caption)
					.foregroundColor(.gray)

				BoldedTextView(
					text: "Your total is $199.99 and you earned 250 points!",
					placeholders: ["$199.99", "250"],
					textColor: .blue,
					defaultFont: .vvTiny,
					alignment: .center
				)
			}
			.padding()
			.previewDisplayName("Center Aligned")

			VStack(spacing: 16) {
				Text("Headline Font + Right Aligned")
					.font(.caption)
					.foregroundColor(.gray)

				BoldedTextView(
					text: "Congratulations Captain! You've unlocked the VIP tier.",
					placeholders: ["Captain", "VIP"],
					textColor: .purple,
					defaultFont: .headline,
					alignment: .trailing
				)
			}
			.padding()
			.previewDisplayName("Right Aligned")
		}
	}
}

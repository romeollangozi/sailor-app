//
//  HTMLTextView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

import SwiftUI

public struct HTMLTextView: View {
	let htmlString: String
	let font: Font

	public init(_ htmlString: String, font: Font = .vvHeading5) {
		self.htmlString = htmlString
		self.font = font
	}

	public var body: some View {
		let attributedString = parseHTML(htmlString: htmlString)
		return Text(attributedString)
			.font(font)
			.padding()
	}

	// Function to parse HTML string into AttributedString
	func parseHTML(htmlString: String) -> AttributedString {
		var attributedString = AttributedString("")

		// Convert HTML string to Data
		if let data = htmlString.data(using: .utf8) {
			do {
				// Parse HTML into NSAttributedString
				let nsAttributedString = try NSAttributedString(
					data: data,
					options: [
						.documentType: NSAttributedString.DocumentType.html,
						.characterEncoding: String.Encoding.utf8.rawValue
					],
					documentAttributes: nil
				)

				// Convert NSAttributedString to SwiftUI's AttributedString
				attributedString = try AttributedString(nsAttributedString, including: \.swiftUI)
			} catch {
				print("Failed to parse HTML: \(error)")
				attributedString = AttributedString("Invalid HTML")
			}
		}

		return attributedString
	}
}


struct HTMLTextViewPreview: View {
	var body: some View {
		HTMLTextView(
			"<p>RockStar living so <b>audaciously</b> cool you might be tempted to smash a guitar (but maybe... don&#39;t). Prime access, keys to the exclusive Richard&#39;s Rooftop, and 24/7 access to RockStar Agents who can (and will) answer your every need.<br />\n<br />\nAnd that&#39;s just the start...</p>\n"
		)
		.background(Color.black)
		.foregroundColor(.white)
		.multilineTextAlignment(.center)
	}
}

#Preview {
	HTMLTextViewPreview()
}

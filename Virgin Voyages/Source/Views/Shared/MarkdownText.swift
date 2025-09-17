//
//  MarkdownText.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/10/24.
//

import SwiftUI

struct MarkdownText: View {
	@Environment(\.openURL) var openURL
	var text: String
    var body: some View {
		Text(text.markdown)
			.environment(\.openURL, OpenURLAction { url in
				.handled
		})
    }
}

#Preview {
	NavigationStack {
		VStack {
			MarkdownText(text: "<a href=\"https://www.virginvoyages.com\">Virgin Voyages</a>")
			MarkdownText(text: "I am **bold**.\n\nI am *italic*.")
		}
	}
}

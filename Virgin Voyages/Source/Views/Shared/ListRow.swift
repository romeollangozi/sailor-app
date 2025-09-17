//
//  ListRow.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/29/24.
//

import SwiftUI
import VVUIKit

struct ListRowModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.frame(maxWidth: .infinity)
			.background(.background)
			.clipShape(RoundedRectangle(cornerRadius: 6))
			.shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 8)
	}
}

extension View {
	func listRowStyle() -> some View {
		self.modifier(ListRowModifier())
	}
}

struct ListRow: View {
	@Environment(\.isEnabled) var isEnabled: Bool
	@Environment(\.contentSpacing) var spacing
	var imageUrl: URL?
	var image: String?
	var vectorImage: String?
	var deckLocation: String?
	var title: String
	var subheading: String?

	var thumbnail: URL? {
		if let imageUrl {
			return imageUrl
		}
		
		if let image {
			return URL(string: image)
		}
		
		return nil
	}
	
	var attributedTitle: AttributedString {
		var string = AttributedString(title)
		string.font = FontStyle.headline.font
		string.foregroundColor = isEnabled ? .primary : .secondary
		
		if let subheading {
			string += "\n"
			var detail = AttributedString(subheading)
			detail.font = FontStyle.subheadline.font
			detail.foregroundColor = .secondary
			string += detail
		}
		
		return string
	}
	
    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack {
				// This is causing a scroll issue when wrapped in a LazyVStack
				if let vectorImage, let url = URL(string: vectorImage) {
					VectorImage(url: url)
						.grayscale(isEnabled ? 0 : 1)
						.frame(width: 60, height: 60)
						.cornerRadius(6)
				} else if let deckLocation {
					DeckLabel(imageUrl: thumbnail, deckLocation: deckLocation)
						.cornerRadius(6)
				} else if let thumbnail {
					ProgressImage(url: thumbnail)
						.grayscale(isEnabled ? 0 : 1)
						.frame(width: 60, height: 60)
						.cornerRadius(6)
				}
				
				VStack(alignment: .leading, spacing: 0) {
					Text(attributedTitle)
						.lineLimit(3)
				}
				.multilineTextAlignment(.leading)
								
				Spacer()
				
				if isEnabled {
					Image(systemName: "chevron.right")
						.foregroundStyle(Color(uiColor: .systemGray4))
				}
			}
			.padding(spacing)
		}
    }
}

#Preview {
    ListRow(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", subheading: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
}

//
//  OfflineDailyUpdateCard.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

struct OfflineDailyUpdateCard: View {

	let image: ImageResource
	let title: String
	let action: () -> Void

	var body: some View {
		Button(action: {
			action()
		}) {
			HStack {
				// Ship icon
				Image(image) // Replace with your actual icon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 64, height: 64)

				// Text
				Text(title)
					.font(.vvBodyBold)
					.foregroundColor(.charcoalBlack)

				Spacer()

				// Arrow icon
				Image(.forwardRed)
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color.white)
			.cornerRadius(16)
			.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
			.padding(.horizontal, Spacing.space16)
		}
		.buttonStyle(PlainButtonStyle())
	}

	public init(image: ImageResource, title: String, action: @escaping () -> Void) {
		self.image = image
		self.title = title
		self.action = action
	}
}

struct OfflineDailyUpdateCard_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			OfflineDailyUpdateCard(
				image: .lineUpIcon,
				title: "Check out today’s happenings"
			) {
				print("Card tapped")
			}
			.previewLayout(.sizeThatFits)
			.padding(.vertical)
			.background(Color(.systemGroupedBackground))
		}
	}
}

//
//  MeEmptyStateView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

import SwiftUI
import VVUIKit

struct MeEmptyStateView: View {
	var imageUrl: String
	var message: String
	var buttonTitle: String
	var showButton: Bool = false
	var action: () -> Void

	var body: some View {
		VStack(spacing: Spacing.space16) {
            URLImage(url: URL(string: imageUrl))
				.frame(width: Sizes.defaultSize64, height: Sizes.defaultSize64)
				.foregroundStyle(Color.iconGray)

			Text(message)
				.font(.vvBody)
				.foregroundColor(.slateGray)
				.multilineTextAlignment(.center)

			if showButton {
				Button(buttonTitle, action: action)
					.buttonStyle(VoyageButtonStyle())
			}
		}
		.frame(maxWidth: 320, maxHeight: .infinity)
        .padding(.top, Spacing.space32)
	}
}

//
//  HomeFooterView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 19.3.25.
//

import SwiftUI
import VVUIKit

struct HomeFooterView: View {
	private let homeFooter: HomeFooterSection

	init(homeFooter: HomeFooterSection) {
		self.homeFooter = homeFooter
	}

	var body: some View {
		VStack(spacing: Spacing.space8) {
			if let url = URL(string: homeFooter.pictogramUrl) {
				DynamicSVGImageLoader(url: url, isLoading: Binding.constant(false))
					.frame(width: Sizes.defaultSize64, height: Sizes.defaultSize64)
			}
			Text(homeFooter.title)
				.font(.vvHeading2Bold)
				.foregroundColor(.blackText)
			Text(homeFooter.description)
				.font(.vvHeading5)
				.foregroundColor(.slateGray)
				.multilineTextAlignment(.center)
		}
		.frame(maxWidth: .infinity)
		.padding(.horizontal, Spacing.space24)
		.padding(.vertical, Spacing.space32)
	}
}

#Preview {
	HomeFooterView(homeFooter: HomeFooterSection.sample())
}


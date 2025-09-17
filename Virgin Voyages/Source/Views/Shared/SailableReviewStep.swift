//
//  ReviewStepContainer.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/16/24.
//

import SwiftUI
import VVUIKit

private struct SailableReviewContainer<Content: View>: View {
	@Environment(\.contentSpacing) var spacing
	var imageUrl: URL?
	@ViewBuilder var content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack {
				Spacer()
				ProgressImage(url: imageUrl)
					.frame(width: 120, height: 120)
			}
			
			VStack(alignment: .leading, spacing: spacing) {
				content()
			}
			.fontStyle(.body)
			.frame(maxWidth: .infinity)
			.padding(EdgeInsets(top: 0, leading: spacing * 2, bottom: spacing * 2, trailing: spacing * 2))
		}
		.background(Color.white)
	}
}

struct SailableReviewStep<Content: View>: View {
	var imageUrl: URL?
	@ViewBuilder var content: () -> Content
	
	var body: some View {
		SailableReviewContainer(imageUrl: imageUrl, content: content)
			.ignoresSafeArea()
	}
}

struct SailableReviewStepScrollable<Content: View>: View {
	@Environment(\.contentSpacing) var spacing
	var imageUrl: URL?
	@ViewBuilder var content: () -> Content
	
	var body: some View {
		ScrollView {
			SailableReviewContainer(imageUrl: imageUrl, content: content)
		}
		.ignoresSafeArea()
	}
}

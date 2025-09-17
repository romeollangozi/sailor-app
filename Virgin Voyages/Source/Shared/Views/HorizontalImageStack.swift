//
//  HorizontalImageStack.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.4.25.
//

import SwiftUI

struct HorizontalImageStack: View {
	let imageUrls: [String]
	var imageSize: CGFloat = 32.0
	var borderWidth: CGFloat = 2
	var overlapOffset: CGFloat = 5
	var defaultImage: String = "ProfilePlaceholder"

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: -overlapOffset) {
				ForEach(imageUrls.indices, id: \.self) { index in
					AuthURLImageView(
						imageUrl: imageUrls[index],
						size: imageSize,
						clipShape: .circle,
						defaultImage: defaultImage
					)
					.overlay(
						Circle()
							.stroke(Color.white, lineWidth: borderWidth)
					)
				}
			}
			.padding(.horizontal, overlapOffset)
		}
		.frame(width: totalContentWidth)
	}

	private var totalContentWidth: CGFloat {
		let count = CGFloat(imageUrls.count)
		let baseWidth = count * imageSize
		let totalOverlap = (count - 1) * overlapOffset
		return baseWidth - totalOverlap + (2 * overlapOffset)
	}
}

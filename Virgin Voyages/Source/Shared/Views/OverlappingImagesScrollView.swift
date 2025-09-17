//
//  OverlappingImagesScrollView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.3.25.
//

import SwiftUI

struct OverlappingImagesScrollView: View {

	// MARK: - Parameters
	let imageUrls: [String]
	var imageSize: CGFloat
	var overlapOffset: CGFloat
	var borderColor: Color
	var borderWidth: CGFloat

	// MARK: - Init
	init(imageUrls: [String] = [], imageSize: CGFloat = 80.0, overlapOffset: CGFloat = 40.0, borderColor: Color = .white, borderWidth: CGFloat = 2.0) {
		self.imageUrls = imageUrls
		self.imageSize = imageSize
		self.overlapOffset = overlapOffset
		self.borderColor = borderColor
		self.borderWidth = borderWidth
	}

	var body: some View {
		GeometryReader { geometry in
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: -overlapOffset) {
					ForEach(Array(imageUrls.enumerated()), id: \.element) { index, url in
						overlappingImageView(url: url, index: index)
					}
				}
				.frame(width: shouldScroll(totalWidth: totalContentWidth(for: geometry.size.width)) ? nil : geometry.size.width,
					   alignment: .center)
				.padding(.vertical, 10)
			}
			.frame(width: geometry.size.width)
		}
		.frame(height: imageSize + 20)
	}

	private func shouldScroll(totalWidth: CGFloat) -> Bool {
		totalWidth > UIScreen.main.bounds.width
	}

	private func totalContentWidth(for availableWidth: CGFloat) -> CGFloat {
		CGFloat(imageUrls.count) * (imageSize - overlapOffset) + overlapOffset
	}

	private func overlappingImageView(url: String, index: Int) -> some View {
		AuthURLImageView(imageUrl: url, size: imageSize, clipShape: .circle, defaultImage: "ProfilePlaceholder")
			.overlay(Circle().stroke(borderColor, lineWidth: borderWidth))
			.zIndex(Double(imageUrls.count - index))
	}
}

// MARK: - Preview
struct OverlappingImagesScrollView_Previews: PreviewProvider {
	static var previews: some View {
		OverlappingImagesScrollView(imageUrls: [
			"https://www.virginvoyages.com/sailorimage1.png",
			"https://www.virginvoyages.com/sailorimage2.png"
		])
		.frame(height: 100)
	}
}

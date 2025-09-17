//
//  FlexibleProgressImage.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 3/4/24.
//

import SwiftUI

public struct FlexibleHeightLayout: Layout {
	public var contentMode: ContentMode?
	public var heightRatio: CGFloat?
	public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		if let width = proposal.width, let heightRatio {
			return CGSize(width: width, height: width * heightRatio)
		}
		
		if contentMode == .fit, let first = subviews.first {
			return first.sizeThatFits(proposal)
		}
 
		return proposal.replacingUnspecifiedDimensions()
	}
	
	public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

	}

	public init(contentMode: ContentMode? = nil, heightRatio: CGFloat? = nil) {
		self.contentMode = contentMode
		self.heightRatio = heightRatio
	}
}

public struct FlexibleProgressImage: View {
	public var url: URL?
	public var heightRatio: CGFloat?
	public var backgroundColor = Color(uiColor: .systemGray6)

	public var body: some View {
		FlexibleHeightLayout(heightRatio: heightRatio) {
			ProgressImage(url: url)
		}
		.background(backgroundColor)
		.clipped()
	}

	public init(url: URL? = nil, heightRatio: CGFloat? = nil, backgroundColor: SwiftUICore.Color = Color(uiColor: .systemGray6)) {
		self.url = url
		self.heightRatio = heightRatio
		self.backgroundColor = backgroundColor
	}
}

#Preview {
    FlexibleProgressImage()
}

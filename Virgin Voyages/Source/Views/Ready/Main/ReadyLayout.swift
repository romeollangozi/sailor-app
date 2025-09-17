//
//  ReadyLayout.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI

struct ReadyLayout: Layout {
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
		proposal.replacingUnspecifiedDimensions()
	}

	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
				
		if subviews.count == 3 {
			let top = subviews[0]
			let middle = subviews[1]
			let bottom = subviews[2]
			
			let squareSize = bounds.size.width
			let remainderHeight = (bounds.size.height - squareSize) / 2.0
			top.place(at: .init(x: bounds.minX, y: bounds.minY), proposal: .init(width: squareSize, height: remainderHeight))
			middle.place(at: .init(x: bounds.minX, y: bounds.minY + remainderHeight), proposal: .init(width: squareSize, height: squareSize))
			bottom.place(at: .init(x: bounds.minX, y: bounds.minY + remainderHeight + squareSize), proposal: .init(width: squareSize, height: remainderHeight))
		}
	}
}

struct ReadyLayoutView<Header: View, Content: View, Footer: View>: View {
	@ViewBuilder var label: () -> Content
	@ViewBuilder var header: () -> Header
	@ViewBuilder var footer: () -> Footer
	
	var body: some View {
		ReadyLayout {
			Rectangle()
				.foregroundStyle(.clear)
				.overlay {
					header()
				}
			Rectangle()
				.foregroundStyle(.clear)
				.overlay {
					label()
				}
			Rectangle()
				.foregroundStyle(.clear)
				.overlay {
					footer()
				}
		}
	}
}

#Preview {
	ReadyLayoutView {
		Text("Body")
			.fontStyle(.body)
	} header: {
		Text("Header")
			.fontStyle(.largeTitle)
	} footer: {
		Text("Footer")
			.fontStyle(.title)
	}
	.ignoresSafeArea()
}

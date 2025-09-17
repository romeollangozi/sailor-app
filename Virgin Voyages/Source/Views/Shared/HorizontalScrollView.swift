//
//  HorizontalScrollView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/5/23.
//

import SwiftUI

struct HorizontalScrollView<Content: View>: View {
	@Environment(\.contentSpacing) var spacing
	@ViewBuilder var content: () -> Content
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(alignment: .top, spacing: spacing) {
					content()
				}
				.padding(EdgeInsets(top: 10, leading: spacing, bottom: 10, trailing: spacing))
		}
		.listRowInsets(EdgeInsets())
		.fixedSize(horizontal: false, vertical: true)
	}
}

#Preview {
	HorizontalScrollView() {
		ForEach(1..<1000) {
			Button("\($0 * 10)") {
				
			}
			.buttonStyle(BorderedProminentButtonStyle())
		}
	}
}

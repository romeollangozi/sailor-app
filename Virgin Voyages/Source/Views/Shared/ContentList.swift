//
//  ContentList.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/5/24.
//

import SwiftUI

struct ContentList<Content: View>: View {
	@Environment(\.contentSpacing) var spacing: CGFloat
	@ViewBuilder var label: () -> Content
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .center, spacing: spacing) {
				label()
					.contentStyle(spacing)
			}
		}
		.background(Color(uiColor: .systemGray6))
	}
}

#Preview {
	ContentList {
		Text("Hello!")
	}
}

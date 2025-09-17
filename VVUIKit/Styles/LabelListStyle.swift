//
//  LabelListStyle.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/12/24.
//

import SwiftUI

public struct LabelListStyle: LabelStyle {
	public func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.icon
				.frame(width: 20)
			configuration.title
		}
	}

	public init() {
	}
}

struct LabelListStyle_Previews: PreviewProvider {
	static var previews: some View {
		VStack(alignment: .leading, spacing: 10) {
			Label("First Item", systemImage: "star.fill")
				.labelStyle(LabelListStyle())

			Label("Second Item", systemImage: "heart.fill")
				.labelStyle(LabelListStyle())

			Label("Third Item", systemImage: "bolt.fill")
				.labelStyle(LabelListStyle())
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}

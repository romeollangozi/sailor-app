//
//  SingleLineSeparator.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI

public struct SingleLineSeparator: View {
	public var body: some View {
		Rectangle()
			.fill(Color.separatorGray)
			.frame(height: 1)
			.edgesIgnoringSafeArea(.horizontal)
	}

	public init() {
	}
}

struct SingleLineSeparator_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Text("Above the line")
			SingleLineSeparator()
			Text("Below the line")
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}

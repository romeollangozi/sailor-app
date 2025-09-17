//
//  ProgressBarView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import SwiftUI

struct ProgressBarView: View {
	@Environment(\.contentSpacing) var spacing
	var text: String?
	var value: Double?
	
    var body: some View {
		VStack(alignment: .center, spacing: spacing) {
			ProgressView("\(text ?? "Loading")...")
				.fontStyle(.headline)
			
			if let value {
				ProgressView(value: value)
			}
		}
		.padding(spacing * 2)
		.interactiveDismissDisabled()
    }
}

#Preview {
	ProgressBarView(text: "Loading", value: 0.5)
}

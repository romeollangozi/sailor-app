//
//  ActivityHighlightSection.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/22/24.
//

import SwiftUI

struct ActivityHighlightSection: View {
	var highlights: [String]
    var body: some View {
		Section {
			ForEach(highlights, id: \.self) { highlight in
				HStack(spacing: 15) {
					Image(systemName: "checkmark")
						.imageScale(.medium)
						.foregroundStyle(.green)
						.fontWeight(.bold)
					Text(highlight)
						.fontStyle(.body)
				}
			}
		} header: {
			Text("Highlights")
				.fontStyle(.title)
				.foregroundStyle(.primary)
		}
    }
}

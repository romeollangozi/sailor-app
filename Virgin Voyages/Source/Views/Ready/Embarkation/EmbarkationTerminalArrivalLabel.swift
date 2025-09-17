//
//  EmbarkationTerminalArrivalLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/29/24.
//

import SwiftUI

struct EmbarkationTerminalArrivalLabel: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	
    var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Text(embarkation.terminalArrivalTimeLabel)
				.fontStyle(.smallTitle)
			
			HStack {
				Grid(alignment: .leading, horizontalSpacing: spacing * 2, verticalSpacing: 5) {
					GridRow {
						Text(embarkation.arrivalTimeLabel)
						Text(embarkation.locationLabel)
					}
					.fontStyle(.subheadline)
					.foregroundStyle(.secondary)
					
					GridRow {
						Text(embarkation.terminalArrivalTimeText ?? "")
						Text(embarkation.portName)
					}
					.fontStyle(.headline)
					.foregroundStyle(.white)
				}
				
				Spacer()
			}
		}
		.padding()
		.background(Color("Title Color"))
		.foregroundStyle(.white)
		.clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

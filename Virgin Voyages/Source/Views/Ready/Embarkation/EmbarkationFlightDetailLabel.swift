//
//  EmbarkationFlightDetailLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/30/24.
//

import SwiftUI

struct EmbarkationFlightDetailLabel: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	var flight: EmbarkationTask.FlightInfo
    var isOutbound: Bool = false

    var body: some View {
		VStack {
			Image("Airplane")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 150)
				.padding(spacing)
			
			HStack {
				Spacer()
				
				Grid(alignment: .leading, horizontalSpacing: spacing) {
					GridRow {
						Text(embarkation.content.pageDetails.labels.airline)
						Text(embarkation.content.pageDetails.labels.flight)
                        Text(isOutbound ? embarkation.content.pageDetails.labels.departureTime : embarkation.content.pageDetails.labels.arrivalTime)
					}
                    .padding(.horizontal)
					.fontStyle(.caption)
					.foregroundStyle(.secondary)
					
					GridRow {
						Text(embarkation.airlineName(from: flight.airline))
						Text(flight.flightNumber)
                        Text(flight.time?.format(.time).lowercased() ?? "")
					}
                    .padding(.horizontal)
					.fontStyle(.body)
				}
				
				Spacer()
			}
		}
		.padding(spacing)
		.background(.white)
		.clipShape(RoundedRectangle(cornerRadius: 8))
		.shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 8)
    }
}

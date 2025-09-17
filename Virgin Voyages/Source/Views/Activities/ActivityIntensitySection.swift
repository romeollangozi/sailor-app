//
//  ActivityIntensitySection.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/22/24.
//

import SwiftUI

fileprivate extension Int {
	var durationText: String {
		let hours = self / 60
		let remainingMinutes = self % 60
		var strings: [String] = []

		if hours > 0 {
			var string = "\(hours) hour"
			if hours != 1 {
				string += "s"
			}

			strings += [string]
		}

		if remainingMinutes > 0 {
			var string = "\(remainingMinutes) min"
			if remainingMinutes != 1 {
				string += "s"
			}

			strings += [string]
		}

		return strings.joined(separator: " ")
	}
}

struct ActivityIntensitySection: View {
	var activityLevel: String
	var duration: Int
	var activityTypes: [String]
    var body: some View {
		Section {
			LabeledContent {
				Text(activityLevel.capitalized)
					.fontStyle(.body)
			} label: {
				Label("Energy Level", systemImage: "bolt.fill")
					.textCase(.uppercase)
					.fontStyle(.subheadline)
			}
		
			LabeledContent {
				Text(duration.durationText)
					.fontStyle(.body)
			} label: {
				Label("Duration", systemImage: "clock.fill")
					.textCase(.uppercase)
					.fontStyle(.subheadline)
			}
			
			if activityTypes.count > 0 {
				LabeledContent {
					Text(activityTypes.map {
						$0.capitalized
					}.joined(separator: ", "))
					.fontStyle(.body)
				} label: {
					Label("Type", systemImage: "beach.umbrella.fill")
						.textCase(.uppercase)
						.fontStyle(.subheadline)
				}
			}
		} header: {
			Text("Itensity")
				.foregroundStyle(.primary)
				.fontStyle(.title)
		}
    }
}

//
//  PregnancyDoneStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct PregnancyDoneStep: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.contentSpacing) var spacing
	var pregnancy: PregnancyTask
	var page: Endpoint.GetPregnancyTask.Response.Page
	
	var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Text(page.title)
				.fontStyle(.title)
			
			Text(page.description)
				.fontStyle(.body)
				.foregroundStyle(.secondary)
			
			Spacer()
			
			Button("Done") {
				dismiss()
			}
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
	}
}

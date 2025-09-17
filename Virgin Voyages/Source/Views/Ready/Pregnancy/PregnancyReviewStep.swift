//
//  PregnancyReviewStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/14/24.
//

import SwiftUI

struct PregnancyReviewStep: View {
	@Environment(\.contentSpacing) var spacing
	var pregnancy: PregnancyTask
	var page: Endpoint.GetPregnancyTask.Response.ReviewPage
	
    var body: some View {
		SailableReviewStep(imageUrl: URL(string: page.imageURL)) {
			Text(page.title)
				.fontStyle(.title)
			
			Text(page.description)
				.fontStyle(.body)
				.foregroundStyle(.secondary)
			
			Spacer()
			
			Button("Change pregnancy declaration") {
				pregnancy.startOver()
			}
			.buttonStyle(TertiaryButtonStyle())
		}
    }
}

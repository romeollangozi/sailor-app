//
//  EmbarkationPriorityBoardingStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/17/24.
//

import SwiftUI

struct EmbarkationPriorityBoardingStep: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	var page: EmbarkationTask.PriorityBoardingPage
	
    var body: some View {
		VStack(alignment: .leading, spacing: spacing * 2) {
			Text(page.header)
				.fontStyle(.largeTitle)
			Text(page.body)
				.fontStyle(.body)
			
			EmbarkationTerminalArrivalLabel()
			
			Spacer()
			
			Button(page.buttonLabel) {
                let slot = embarkation.content.availableSlots?.first
                embarkation.boardingStep = .confirm(slot)
                if !embarkation.isMegaRockStar {
                    embarkation.transportationStep = .skip
                }
			}
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
    }
}

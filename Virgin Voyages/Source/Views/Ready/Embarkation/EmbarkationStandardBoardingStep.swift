//
//  EmbarkationStandardBoardingStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/17/24.
//

import SwiftUI

struct EmbarkationStandardBoardingStep: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	
    var body: some View {
		VStack(alignment: .leading, spacing: spacing * 2) {
			if let flyingInQuestion = embarkation.content.pageDetails.nonVipFlowContent.embarkSlotPage.flyingInQuestion {
				Text(flyingInQuestion)
					.fontStyle(.largeTitle)
			}

			if let notFlyingInQuestion = embarkation.content.pageDetails.nonVipFlowContent.embarkSlotPage.notFlyingInQuestion {
				Text(notFlyingInQuestion)
					.fontStyle(.body)
			}

			EmbarkationTerminalArrivalLabel()
			
			Spacer()
			
			VStack(alignment: .leading, spacing: spacing) {
				Text("Select a timeslot")
					.fontStyle(.headline)
				
				if let slots = embarkation.content.availableSlots {
					HFlowStack(alignment: .leading) {
						ForEach(slots, id: \.number) { slot in
							if let time = slot.time.time {
								Button(time.format(.time)) {
									embarkation.boardingStep = .select(slot)
								}
								.buttonStyle(PrimaryCapsuleButtonStyle())
							}
						}
					}
				}
			}
		}
		.sailableStepStyle()
    }
}

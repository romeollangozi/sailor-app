//
//  EmbarkationParkStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/3/24.
//

import SwiftUI

struct EmbarkationParkStep: View {
	@Environment(\.contentSpacing) var spacing
	@Environment(EmbarkationTask.self) var embarkation
	
    var body: some View {
		@Bindable var embarkation = embarkation
		VStack(alignment: .leading, spacing: spacing * 2) {
			Text(embarkation.content.pageDetails.nonVipFlowContent.parkingOptPage.onEmbarkDayQuestion)
				.fontStyle(.title)
			
			Text(embarkation.content.pageDetails.nonVipFlowContent.parkingOptPage.parkingBody)
				.fontStyle(.body)
			
			EmbarkationTerminalArrivalLabel()
			
			Spacer()
			
			Text(embarkation.content.pageDetails.nonVipFlowContent.parkingOptPage.onEmbarkDayQuestion)
				.fontStyle(.headline)
			
			HStack {
				Button(embarkation.content.pageDetails.buttons.yes) {
					embarkation.transportationStep = .yes
				}
				.buttonStyle(PrimaryCapsuleButtonStyle())
				
				Button(embarkation.content.pageDetails.buttons.no) {
					embarkation.transportationStep = .no
				}
				.buttonStyle(PrimaryCapsuleButtonStyle())
			}
		}
		.sailableStepStyle()
    }
}

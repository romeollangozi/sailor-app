//
//  EmbarkationArrivalStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/23/24.
//

import SwiftUI

struct EmbarkationArrivalStep: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	@State private var saveTask = ScreenTask()
	
    var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Spacer()
			
			Text(embarkation.content.pageDetails.flightPage.question)
				.fontStyle(.headline)
			
			Text(embarkation.content.pageDetails.flightPage.description)
				.fontStyle(.body)
			
			HStack {
				TaskButton(title: embarkation.content.pageDetails.buttons.no, task: saveTask) {
					embarkation.flyingIn = .no
				}
				.buttonStyle(PrimaryCapsuleButtonStyle())
				
				Button(embarkation.content.pageDetails.buttons.yesSameDay) {
					embarkation.flyingIn = .yes
				}
				.buttonStyle(PrimaryCapsuleButtonStyle())
			}
		}
		.disabled(saveTask.disabled)
		.sailableStepStyle()
    }
}

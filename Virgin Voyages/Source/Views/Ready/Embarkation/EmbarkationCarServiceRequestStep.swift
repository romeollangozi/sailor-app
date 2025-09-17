//
//  EmbarkationCarServiceRequestStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/17/24.
//

import SwiftUI

struct EmbarkationCarServiceRequestStep: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	
    var body: some View {
		let arriveInStyle = embarkation.content.pageDetails.boardingWindowContent.arrivalStyle
		VStack(alignment: .leading, spacing: spacing * 2) {
			Text(arriveInStyle.header)
				.fontStyle(.largeTitle)
			Text(arriveInStyle.description)
				.fontStyle(.body)
			
			EmbarkationTerminalArrivalLabel()
			
			Spacer()
			
			VStack {
				HStack {
					Button(arriveInStyle.buttons.yes) {
						embarkation.transportationStep = .yes
					}
					.buttonStyle(PrimaryCapsuleButtonStyle())
					
					Button(arriveInStyle.buttons.no) {
						embarkation.transportationStep = .no
					}
					.buttonStyle(PrimaryCapsuleButtonStyle())
				}
				
				Button(arriveInStyle.buttons.skip) {
					embarkation.transportationStep = .skip
				}
				.buttonStyle(TertiaryButtonStyle())
			}
		}
		.sailableStepStyle()
    }
}

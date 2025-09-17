//
//  PregnancyStartStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct PregnancyStartStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.contentSpacing) var spacing
	@Bindable var pregnancy: PregnancyTask
	@State private var screenTask = ScreenTask()

	var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Spacer()

			Text(pregnancy.content.questionPage.title)
				.fontStyle(.headline)
			Text(pregnancy.content.questionPage.description)

			HStack {
				Button(pregnancy.content.buttons.yes) {
					pregnancy.startInterview()
				}
				.disabled(screenTask.disabled)
				.buttonStyle(PrimaryCapsuleButtonStyle())
				
				TaskButton(title: pregnancy.content.buttons.no, task: screenTask) {
					let fitToTravel = try await authenticationService.currentSailor().save(pregnant: .no)
                    pregnancy.update(pregnant: false, fitToTravel: fitToTravel)
				}
				.buttonStyle(PrimaryCapsuleButtonStyle())
			}
		}
		.sailableStepStyle()
	}
}

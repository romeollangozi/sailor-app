//
//  PregnancyWeekStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct PregnancyWeekStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.contentSpacing) var spacing
	@Bindable var pregnancy: PregnancyTask
	@State private var saveTask = ScreenTask()
	@State private var alternateTask = ScreenTask()

	var body: some View {
		VStack(alignment: .center, spacing: spacing) {		
			Spacer()
			
			VStack(alignment: .leading, spacing: spacing) {
				Text(pregnancy.content.noOfWeeksPage.title)
					.fontStyle(.headline)
				Text(pregnancy.content.noOfWeeksPage.description)
					.fontStyle(.body)
					.foregroundStyle(.secondary)
                TextInputField(placeholder: pregnancy.content.labels.weeks, error: pregnancy.validationErrorMsg, text: $pregnancy.numberOfWeeks)
					.keyboardType(.numberPad)
					.disabled(alternateTask.disabled || saveTask.disabled)
			}
			.disabled(saveTask.disabled || alternateTask.disabled)

			TaskButton(title: "Next", task: saveTask) {
                if pregnancy.isNOWeeksEmpty {
                    pregnancy.showErrorMsg = true
                    return
                }
				let fitToTravel = try await authenticationService.currentSailor().save(pregnant: .yes(Int(pregnancy.numberOfWeeks) ?? 0))
				pregnancy.update(pregnant: true, fitToTravel: fitToTravel)
			}
			.disabled(alternateTask.disabled)
			.buttonStyle(PrimaryButtonStyle())
			
			TaskButton(title: pregnancy.content.buttons.dontKnow, underline: true, task: alternateTask) {
				let fitToTravel = try await authenticationService.currentSailor().save(pregnant: .dontKnow)
                pregnancy.update(pregnant: true, fitToTravel: fitToTravel, dontKnowFlag: true)
			}
			.disabled(saveTask.disabled)
			.buttonStyle(TertiaryButtonStyle())
		}
		.sailableStepStyle()
	}
}

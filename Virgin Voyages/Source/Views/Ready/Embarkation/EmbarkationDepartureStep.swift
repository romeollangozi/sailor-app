//
//  EmbarkationDepartureStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/23/24.
//

import SwiftUI

struct EmbarkationDepartureStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	@Environment(\.dismiss) var dismiss
	@State private var saveTask = ScreenTask()
    @State private var skipTask = ScreenTask()

	var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Text(embarkation.content.pageDetails.postVoyagePlansContent.introPage.title)
                .fontStyle(.largeTitle)

			Text(embarkation.content.pageDetails.postVoyagePlansContent.introPage.description)
                .fontStyle(.largeTagline)
                .foregroundColor(.vvGray)

            Spacer()
            
            Text(embarkation.content.pageDetails.postVoyagePlansContent.introPage.flyingOutQuestion)
                .fontStyle(.headline)
                .foregroundColor(.blackText)

            HStack {
                TaskButton(title: embarkation.content.pageDetails.buttons.no, task: saveTask) {
                    embarkation.flyingOut = .no
                    try await authenticationService.currentSailor().save(embarkation: embarkation)
                    dismiss()
                }
                .buttonStyle(PrimaryCapsuleButtonStyle())

                Button(embarkation.content.pageDetails.buttons.yesSameDay) {
                    embarkation.flyingOut = .yes
                }
                .buttonStyle(PrimaryCapsuleButtonStyle())
            }
            .frame(height: 66)

            TaskButton(title: embarkation.content.pageDetails.buttons.skip, underline: true, task: skipTask) {
                embarkation.flyingOut = .skip
                try await authenticationService.currentSailor().save(embarkation: embarkation)
                dismiss()
            }
            .buttonStyle(TertiaryButtonStyle())
		}
        .disabled(saveTask.disabled || skipTask.disabled)
		.sailableStepStyle()
	}
}

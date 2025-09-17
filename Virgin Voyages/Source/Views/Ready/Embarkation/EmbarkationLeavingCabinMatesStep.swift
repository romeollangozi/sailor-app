//
//  EmbarkationLeavingCabinMatesStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 11/1/24.
//

import SwiftUI

struct EmbarkationLeavingCabinMatesStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
	@Environment(\.dismiss) var dismiss
	@State private var saveTask = ScreenTask()
	@State private var expanded = true
	
    var body: some View {
		@Bindable var embarkation = embarkation
		VStack(alignment: .leading, spacing: spacing * 2) {
			EmbarkationFlightDetailLabel(flight: embarkation.departureFlight, isOutbound: true)
			
			Spacer()
			
			VStack(alignment: .leading, spacing: spacing) {
				ThinDoubleDivider()
				
				Button {
					expanded.toggle()
				} label: {
					HStack {
						Text(embarkation.content.pageDetails.postVoyagePlansContent.partyMembersPostCruiseExpand.title)
							.fontStyle(.headline)
						
						Spacer()
						Image(systemName: expanded ? "chevron.down" : "chevron.up")
							.imageScale(.small)
					}
				}
				.tint(.primary)
				
				Text("We can give them the same embarkation slot so you can all board together")
					.fontStyle(.body)
				
				if expanded {
                    if embarkation.postVoyagePartyMembers.count > 0 {
						ForEach($embarkation.postVoyagePartyMembers) { $partyMember in
							EmbarkationPartyMemberButton(partyMember: $partyMember)
							if partyMember != embarkation.partyMembers.last {
								Divider()
							}
						}
					}
				}
				
				ThinDoubleDivider()
			}
			
			TaskButton(title: "Next", task: saveTask) {
				try await authenticationService.currentSailor().save(embarkation: embarkation)
				dismiss()
			}
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
    }
}

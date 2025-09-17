//
//  EmbarkationArrivingCabinMatesStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/29/24.
//

import SwiftUI

struct EmbarkationArrivingCabinMatesStep: View {
	@Environment(\.contentSpacing) var spacing
	@Environment(EmbarkationTask.self) var embarkation
	@State var expanded = true
	
    var body: some View {
		@Bindable var embarkation = embarkation
		VStack(alignment: .leading, spacing: spacing * 2) {
			EmbarkationTerminalArrivalLabel()
		
			Spacer()
			
			VStack(alignment: .leading, spacing: spacing) {
				ThinDoubleDivider()
				
				Button {
					expanded.toggle()
				} label: {
					HStack {
						Text(embarkation.content.pageDetails.nonVipFlowContent.partyMembersSlotExpand.title)
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
					if embarkation.partyMembersWithoutSlot.count > 0 {
						ForEach($embarkation.partyMembersWithoutSlot) { $partyMember in
							EmbarkationPartyMemberButton(partyMember: $partyMember)
							if partyMember != embarkation.partyMembersWithoutSlot.last {
								Divider()
							}
						}
					}
					
					if embarkation.partyMembersWithSlot.count > 0 {
						Text(embarkation.content.pageDetails.nonVipFlowContent.partyMembersSlotExpand.alreadySelectedSlotDescription)
							.fontStyle(.caption)
							.padding(.vertical, spacing)
						
						ForEach($embarkation.partyMembersWithSlot) { $partyMember in
							EmbarkationPartyMemberButton(partyMember: $partyMember)
							if partyMember != embarkation.partyMembersWithSlot.last {
								Divider()
							}
						}
					}
				}
				
				ThinDoubleDivider()
			}

			Button("Next") {
				embarkation.arrivingWithYouStep = .complete
			}
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
    }
}

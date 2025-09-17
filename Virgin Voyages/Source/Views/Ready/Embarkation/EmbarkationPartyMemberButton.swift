//
//  EmbarkationPartyMemberButton.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 11/1/24.
//

import SwiftUI

struct EmbarkationPartyMemberButton: View {
	@Environment(\.contentSpacing) var spacing
	@Binding var partyMember: EmbarkationTask.PartyMember
	
    var body: some View {
		Button {
			partyMember.selected.toggle()
		} label: {
			HStack(spacing: spacing) {
				Image(systemName: partyMember.selected ? "checkmark.square.fill" : "square")
					.foregroundStyle(.black, Color(hex: "D9F4F9"))
					.imageScale(.large)
				if let url = partyMember.imageURL {
					AuthenticatedProgressImage(url: url)
						.frame(width: 32, height: 32)
						.background(.white)
						.clipShape(Circle())
				}
				Text(partyMember.name)
					.fontStyle(.body)
			}
		}
		.tint(.primary)
    }
}

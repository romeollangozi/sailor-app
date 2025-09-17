//
//  EmergencyContactScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import SwiftUI

struct EmergencyContactScreen: View {
	@Environment(\.contentSpacing) var spacing
	@State var contact: EmergencyContactTask
	
    var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			switch contact.step {
			case .name:
				EmergencyContactNameStep(contact: contact)
					.background(contact.backgroundColor)
			case .relation:
				EmergencyContactRelationStep(contact: contact)
					.background(contact.backgroundColor)
			case .phone:
				EmergencyContactPhoneStep(contact: contact)
					.background(contact.backgroundColor)
			case .done:
				EmergencyContactReviewStep(contact: contact)
			}
		}
		.sailableToolbar(task: contact)
		.confirmationDialog(contact.content.labels.relationship, isPresented: $contact.showRelationshipSheet) {
			ForEach(contact.relations, id: \.code) { relation in
				Button(relation.name) {
                    contact.relationship = relation.code
				}
			}
		}
    }
}

//
//  EmergencyContactRelationStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct EmergencyContactRelationStep: View {
	@Environment(\.contentSpacing) var spacing
	@Bindable var contact: EmergencyContactTask

	var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Spacer()
			
			Text(contact.content.relationshipPage.title)
				.fontStyle(.headline)
	
            InputFieldPicker(placeholder: contact.content.labels.relationship, text: Binding(
                get: { contact.relationshipName },
                set: { newName in
                    if let relation = contact.relations.first(where: { $0.name == newName }) {
                        contact.relationship = relation.code
                    }
                }
            ), presented: $contact.showRelationshipSheet)

			Button("Next") {
				contact.save()
			}
			.buttonStyle(PrimaryButtonStyle())
			.disabled(contact.relationship == "")
		}
		.sailableStepStyle()
	}
}

//
//  EmergencyContactNameStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct EmergencyContactNameStep: View {
	@Environment(\.contentSpacing) var spacing
	@Bindable var contact: EmergencyContactTask
	
	var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Spacer()
			
			Text(contact.content.contactNamePage.title)
				.fontStyle(.headline)
			
			NameInputField(placeholder: contact.content.labels.name, text: $contact.name)
			
			Button("Next") {
				contact.save()
			}
			.disabled(contact.name == "")
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
	}
}

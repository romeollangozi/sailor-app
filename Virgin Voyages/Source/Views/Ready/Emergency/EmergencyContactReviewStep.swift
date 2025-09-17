//
//  EmergencyContactReviewStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct EmergencyContactReviewStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.dismiss) var dismiss
	@Environment(\.contentSpacing) var spacing
	@Bindable var contact: EmergencyContactTask
	@State private var saveTask = ScreenTask()
	@State private var deleteTask = ScreenTask()
	
	var body: some View {
		SailableReviewStep(imageUrl: URL(string: contact.content.reviewPage.imageURL)) {
			HStack(alignment: .bottom, spacing: spacing) {
				Text(contact.content.reviewPage.title)
					.multilineTextAlignment(.leading)
					.fontStyle(.largeTitle)
				
				Spacer()
				
				TaskButton(systemImage: "trash", task: deleteTask) {
					try await authenticationService.currentSailor().delete(emergencyContact: contact)
					contact.discardChanges()
				}
				.disabled(saveTask.disabled)
			}
			
			NameInputField(placeholder: contact.content.labels.name, text: $contact.name)
				.disabled(saveTask.disabled || deleteTask.disabled)
			
            InputFieldPicker(placeholder: contact.content.labels.relationship, text: Binding(
                get: { contact.relationshipName },
                set: { newName in
                    if let relation = contact.relations.first(where: { $0.name == newName }) {
                        contact.relationship = relation.code
                    }
                }
            ), presented: $contact.showRelationshipSheet)
				.disabled(saveTask.disabled || deleteTask.disabled)
			
			HStack {
                DialingCodeField(placeholder: contact.content.labels.phoneCode, text: $contact.countryCode, countries: contact.countries)
                    .frame(width: 100)

				PhoneInputField(placeholder: contact.content.labels.phoneNumber, text: $contact.phoneNumber)
			}
			.disabled(saveTask.disabled || deleteTask.disabled)
			
			VStack {
				TaskButton(title: "Save changes", task: saveTask) {
					try await authenticationService.currentSailor().save(emergencyContact: contact)
				}
				.buttonStyle(PrimaryButtonStyle())
				.disabled(deleteTask.disabled || !contact.saveIsEnabled())
				
				Button("Cancel") {
					dismiss()
				}
				.disabled(saveTask.disabled || deleteTask.disabled)
				.buttonStyle(TertiaryButtonStyle())
			}
			.padding(30)
			
			Spacer()
		}
	}
}

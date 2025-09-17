//
//  EmergencyContactPhoneStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI

struct EmergencyContactPhoneStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.contentSpacing) var spacing
	@Environment(\.dismiss) var dismiss
	@Bindable var contact: EmergencyContactTask
	@State private var screenTask = ScreenTask()
	
	var body: some View {
		VStack(alignment: .leading, spacing: spacing) {
			Spacer()
			
			Text(contact.content.contactNumberPage.title)
				.fontStyle(.headline)
			
			HStack(spacing: spacing) {
				DialingCodeField(placeholder: contact.content.labels.phoneCode, text: $contact.countryCode, countries: contact.countries)
					.frame(width: 100)

				PhoneInputField(placeholder: contact.content.labels.phoneNumber, text: $contact.phoneNumber)
			}
			.disabled(screenTask.disabled)
			
			TaskButton(title: "Save contact", task: screenTask) {
				try await authenticationService.currentSailor().save(emergencyContact: contact)
				dismiss()
			}
			.disabled(screenTask.disabled || contact.phoneNumber == "" || contact.countryCode == "")
			.buttonStyle(PrimaryButtonStyle())
		}
		.sailableStepStyle()
	}
}

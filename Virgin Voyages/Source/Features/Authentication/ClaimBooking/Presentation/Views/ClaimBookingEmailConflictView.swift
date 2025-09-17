//
//  ClaimBookingEmailConflictView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/12/24.
//

import SwiftUI
import VVUIKit

extension ClaimBookingEmailConflictView {
	static func create(email: String,
					   reservationNumber: String,
					   reservationGuestID: String) -> ClaimBookingEmailConflictView {
        
		let viewModel = ClaimBookingEmailConflictViewModel(email: email,
														   reservationNumber: reservationNumber,
														   reservationGuestID: reservationGuestID)
		return ClaimBookingEmailConflictView(viewModel: viewModel)
	}
}

struct ClaimBookingEmailConflictView: View {

	@State private var viewModel: ClaimBookingEmailConflictViewModel

	init(viewModel: ClaimBookingEmailConflictViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		toolbar
		VStack(spacing: Spacing.space24) {
			header
			emailSelectionForm
			callToActionButtons
			Spacer()
		}
		.padding(.horizontal, Spacing.space24)
	}

	private var toolbar: some View {
		Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
		}
	}

	private var header: some View {
		VStack(alignment: .leading, spacing: Spacing.space24) {
			Text("Select the email you would like to use for voyage updates ")
				.fontStyle(.largeTitle)
			Text("Your booking email is different to the one you use to login to your account.  Select your preferred email for voyage updates. This will not change your login username.")
				.fontStyle(.largeTagline)
				.foregroundColor(Color(hex: "#686D72"))
		}
	}

	private var emailSelectionForm: some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			ForEach(Array(viewModel.emails.enumerated()), id: \.offset) { index, email in
				HStack(spacing: 0) {
					RadioButton(text: email,
								selected: $viewModel.selectedEmail,
								mode: email)
					Spacer()
				}
			}
		}
	}

	private var callToActionButtons: some View {
		VStack(alignment: .center, spacing: Spacing.space16) {
			Button("Next") {
				viewModel.next { selectedGuest in
					viewModel.openCheckBookingDetailsView()
				}
			}
			.buttonStyle(PrimaryButtonStyle())
			.disabled(viewModel.isNextButtonDisabled)

			Button("Cancel") {
                viewModel.navigateBackToRoot()
			}
			.buttonStyle(TertiaryButtonStyle())
		}
        .padding(.top, Spacing.space16)
	}
}


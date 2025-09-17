//
//  ClaimBookingManualEntryView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/16/24.
//

import SwiftUI
import VVUIKit

extension ClaimBookingManualEntryView {
	static func create() -> ClaimBookingManualEntryView  {
		ClaimBookingManualEntryView(viewModel: ClaimBookingManualEntryViewModel())
	}
}

struct ClaimBookingManualEntryView: View {

	@State private var viewModel: ClaimBookingManualEntryViewModel

    init(viewModel: ClaimBookingManualEntryViewModel) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		toolbar
		VStack(spacing: 24.0) {
			header
			formView
            reCaptcha
			callToActionButtons
			Spacer()
		}
		.padding(.horizontal, 24.0)
		.fullScreenCover(isPresented: $viewModel.shouldShowBookingNotFoundModal) {
			ErrorSheetModal(title: "Well, that’s awkward.",
							subheadline: "We still can’t find your booking. Please make sure you enter your details exactly as they appear on your confirmation email. If you are still having problems, contact Sailor Services.",
							primaryButtonText: "Ok",
							secondaryButtonText: "Contact Sailor Services",
							primaryButtonAction: {
				viewModel.closeBookingNotFoundModal()
			}, secondaryButtonAction: {
				callSailorServices()
			}, dismiss: {
				viewModel.closeBookingNotFoundModal()
			})
			.presentationBackground(Color.black.opacity(0.75))
		}
	}

	private var toolbar: some View {
		Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
		}
	}

	private var header: some View {
		VStack(alignment: .leading, spacing: 24.0) {
			Text("Claim a booking")
				.fontStyle(.largeTitle)
			Text("Enter your details exactly as they appear on your booking confirmation. If there are spelling mistakes or errors you can update these later by calling sailor services")
				.fontStyle(.largeTagline)
				.foregroundColor(Color(hex: "#686D72"))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
		}
	}

	private var formView: some View {
		VStack(spacing: 16.0) {
			TextInputField(placeholder: "Last name", text: $viewModel.lastName)
				.textContentType(.familyName)
			DatePickerView(headerText: "Date of Birth",
						   selectedDateComponents: $viewModel.dateOfBirth,
						   error: viewModel.dateOfBirthError)
			TextInputField(placeholder: "Booking reference", text: $viewModel.bookingReferenceNumber)
		}
	}
    
    private var reCaptcha: some View {
        VStack (alignment: .center) {
            reCaptchaView()
                .padding(.horizontal, Paddings.defaultVerticalPadding16)
                .padding(.top, 8.0)
        }.frame(maxWidth: .infinity)
    }
    
    private func reCaptchaView() -> some View {
        ReCaptchaView(viewModel: ReCaptchaViewModel(action: ReCaptchaActions.claimABooking.key) ,confirmed: { status, token in
            viewModel.reCaptchaToken = token
            viewModel.reCaptchaIsChecked = status
        })
        .id(viewModel.reCaptchaRefreshID) // Triggers view refresh
    }

	private var callToActionButtons: some View {
		VStack(alignment: .center, spacing: 16) {
			Button("Search") {
				viewModel.search { result in
					switch result {
					case .successRequiresAuthentication:
                        viewModel.openRequiresAuthenticationView()
					case .bookingNotFound:
                        viewModel.showBookingNotFoundModal()
					case .emailConflict(let email, let reservationNumber, let reservationGuestID):
                        viewModel.OpenEmailConflictView(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID)
                    case .guestConflict(_, let guestDetails):
                        viewModel.openGuestConflict(guestDetails: guestDetails)
					case .success:
						return
					}
				}
			}
			.buttonStyle(PrimaryButtonStyle())
			.disabled(viewModel.isSearchButtonDisabled)

			Button("Cancel") {
                viewModel.navigateBackToRoot()
			}
			.buttonStyle(TertiaryButtonStyle())
		}.padding(.top, 16.0)
	}

	private func callSailorServices() {
		if let phoneURL = URL(string: "tel://\(viewModel.sailorServicesPhoneNumber)") {
			if UIApplication.shared.canOpenURL(phoneURL) {
				UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
			} else {
				print("Phone call not available.")
			}
		}
	}

}

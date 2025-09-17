//
//  ClaimBookingReservationDetailsView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import SwiftUI
import VVUIKit

extension ClaimBookingReservationDetailsView {
    static func create(showCloseFlowButton: Bool = false, onCloseButtonTapped: VoidCallback? = nil) -> ClaimBookingReservationDetailsView {
        let viewModel = ClaimBookingReservationDetailsViewModel(showCloseFlowButton: showCloseFlowButton)
        return ClaimBookingReservationDetailsView(viewModel: viewModel, onCloseButtonTapped: onCloseButtonTapped)
    }
}

struct ClaimBookingReservationDetailsView: View {
    
    @State private var viewModel: ClaimBookingReservationDetailsViewModel
    private let onCloseButtonTapped: VoidCallback?
    
    init(viewModel: ClaimBookingReservationDetailsViewModel,
         onCloseButtonTapped: VoidCallback? = nil) {
        _viewModel = State(wrappedValue:viewModel)
        self.onCloseButtonTapped = onCloseButtonTapped
    }
    
    var body: some View {
        VStack {
            toolbar
            ScrollView {
                VStack(alignment: .leading, spacing: 24.0) {
                    header
                    form
                    reCaptcha
                    callToActionButtons
                    Spacer()
                }
                .padding(.horizontal, 24.0)
                .sheet(isPresented: $viewModel.isBookingReferenceInfoModalVisible) {
                    BookingReferenceInfoSheet(close: {
                        viewModel.toggleBookingReferenceInfoModal()
                    })
                    .presentationDetents([.height(300)])
                }
            }
        }
    }
    
    private var toolbar: some View {
        Toolbar(buttonStyle: viewModel.showCloseFlowButton ? .closeButton : .backButton) {
            if viewModel.showCloseFlowButton {
                (onCloseButtonTapped ?? { print("ClaimBookingReservationDetailsView Error - onCloseButtonTapped not implemented!")} )()
            } else {
                viewModel.navigateBack()
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 24.0) {
            Text("Claim a booking")
                .fontStyle(.largeTitle)
            Text("Enter your reservation ID, found on your booking confirmation email")
                .fontStyle(.largeTagline)
                .foregroundColor(Color(hex: "#686D72"))
        }
    }
    
    private var form: some View {
        VStack(spacing: 16.0) {
            LockedTextField(title: "Last name",
                            text: viewModel.sailorLastName ?? "")
            LockedTextField(title: "Date of Birth",
                            text: viewModel.sailorDateOfBirth ?? "")
			IconTextField(title: "Booking Reference",
						  text: $viewModel.reservationNumber,
						  systemName: "info.circle.fill",
                          keyboardType: .numberPad,
						  onButtonTap: {
				viewModel.toggleBookingReferenceInfoModal()
			})
        }
    }
    
    private var callToActionButtons: some View {
        VStack(alignment: .center, spacing: 16) {
            Button("Search") {
				viewModel.claimBooking { result in
					switch result {
					case .successRequiresAuthentication:
                        viewModel.openRequiresAuthenticationView()
					case .bookingNotFound:
                        viewModel.openBookingNotFound()
					case .emailConflict(let email, let reservationNumber, let reservationGuestID):
                        viewModel.OpenEmailConflictView(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID)
                    case .guestConflict( _, let guestDetails):
                        viewModel.openGuestConflict(guestDetails: guestDetails)
					case .success:
						return
					}
				}
            }
            .buttonStyle(PrimaryButtonStyle())
			.disabled(viewModel.isSearchButtonDisabled)

            Button("Cancel") {
                if viewModel.showCloseFlowButton {
                    (onCloseButtonTapped ?? { print("ClaimBookingReservationDetailsView Error - onCloseButtonTapped not implemented!")} )()
                } else {
                    viewModel.cancel()
                }
            }
            .buttonStyle(TertiaryButtonStyle())
        }.padding(.top, 16.0)
    }
    
    private var reCaptcha: some View {
        VStack (alignment: .center) {
            reCaptchaView()
                .padding(.horizontal, Paddings.defaultVerticalPadding16)
                .padding(.top, 8.0)
        }.frame(maxWidth: .infinity)
    }
    
    private func reCaptchaView() -> some View {
        ReCaptchaView(viewModel: ReCaptchaViewModel(action: ReCaptchaActions.claimABooking.key), confirmed: { status, token in
            viewModel.reCaptchaToken = token
            viewModel.reCaptchaIsChecked = status
        })
        .id(viewModel.reCaptchaRefreshID)
    }

}

//
//  ClaimBookingSelectSailorView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/17/24.
//

import SwiftUI
import VVUIKit

protocol ClaimBookingSelectSailorViewModelProtocol {
    var guestDetails: [ClaimBookingGuestDetails] { get }

    var state: ClaimBookingSelectSailorViewModelState? { get }
    var selectedGuest: ClaimBookingGuestDetails? { get set }
    var isNextButtonDisabled: Bool { get }
    
    func navigateBack()
    func autoSelectCurrentUser() async
    func cancel()
    func openBookingNotFound()
    func openRequiresAuthenticationView()
    func openGuestConflict(guestDetails: [ClaimBookingGuestDetails])
    func openCheckBookingDetails(selectedGuest: ClaimBookingGuestDetails)
    func openMissingBookingDetails(selectedGuest: ClaimBookingGuestDetails)
}

extension ClaimBookingSelectSailorView {
    static func create(currentGuest: ClaimBookingGuestDetails?, bookingReference: String, guestDetails: [ClaimBookingGuestDetails]) -> ClaimBookingSelectSailorView {
        let viewModel = ClaimBookingSelectSailorViewModel(currentGuest: currentGuest, bookingReferenceNumber: bookingReference, guestDetails: guestDetails)
        return ClaimBookingSelectSailorView(viewModel: viewModel)
    }
}

struct ClaimBookingSelectSailorView: View {

    @State private var viewModel: ClaimBookingSelectSailorViewModelProtocol

    init(viewModel: ClaimBookingSelectSailorViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        toolbar
        VStack(spacing: 24.0) {
            header
            emailSelectionForm
            callToActionButtons
            Spacer()
        }
		.onChange(of: viewModel.state) {
			switch viewModel.state {
			case .successRequiresAuthentication:
                viewModel.openRequiresAuthenticationView()
			case .bookingNotFound:
                viewModel.openBookingNotFound()
			case .guestConflict(let guestDetails):
                viewModel.openGuestConflict(guestDetails: guestDetails)
			case .none:
				return
			}
		}
        .padding(.horizontal, 24.0)
        .task {
            await viewModel.autoSelectCurrentUser()
        }
    }

    private var toolbar: some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 24.0) {
            Text("We found your booking")
                .fontStyle(.largeTitle)
			Text("Looks like there are \(viewModel.guestDetails.count) of you in the cabin. Please select yourself from the list below")
                .fontStyle(.largeTagline)
                .foregroundColor(Color(hex: "#686D72"))
        }
    }

    private var emailSelectionForm: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(viewModel.guestDetails.enumerated()), id: \.offset) { index, guestDetails in
                HStack(spacing: 0) {
                    RadioButton(text: guestDetails.name,
                                selected: $viewModel.selectedGuest,
                                mode: guestDetails)
                    Spacer()
                }
            }
        }
    }

    private var callToActionButtons: some View {
        VStack(alignment: .center, spacing: 16) {
            Button("Next") {
                guard let guest = viewModel.selectedGuest else { return }
                if guest.birthDate == nil {
                    viewModel.openMissingBookingDetails(selectedGuest: guest)
                } else {
                    viewModel.openCheckBookingDetails(selectedGuest: guest)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.isNextButtonDisabled)

            Button("Cancel") {
                viewModel.cancel()
            }
            .buttonStyle(TertiaryButtonStyle())
        }.padding(.top, 16.0)
    }
}

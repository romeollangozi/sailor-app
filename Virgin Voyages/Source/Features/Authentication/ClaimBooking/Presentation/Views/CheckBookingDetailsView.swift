//
//  CheckBookingDetailsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.12.24.
//

import SwiftUI
import VVUIKit

struct CheckBookingDetailsView: View {
    
    @State var viewModel: CheckBookingDetailsViewModelProtocol
    
    init(viewModel: CheckBookingDetailsViewModelProtocol =
         CheckBookingDetailsViewModel(
            claimBookingCheckDetailsUseCase: ClaimBookingCheckDetailsUseCase(
            sailorProfileDetails: ClaimBookingGuestDetails.empty()),
            bookingReferenceNumber: "",
            selectedGuest: ClaimBookingGuestDetails.empty(),
            claimBookingCheckDetails: ClaimBookingCheckDetails.empty())
    ) {   
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            toolbar()

            ScrollView {
                VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding32) {
                    title()
                    descriptionView()
                    bookingDetails()
                    Spacer()
                    buttons()
                }
            }
            .padding(Paddings.defaultHorizontalPadding)
        }
        .onAppear {
            viewModel.execute()
        }
    }
    
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }
    
    private func title() -> some View {
        Text(viewModel.claimBookingCheckDetails.title)
            .fontStyle(.largeCaption)
    }
    
    private func descriptionView() -> some View {
        Text(viewModel.claimBookingCheckDetails.description)
            .fontStyle(.subheadline)
            .foregroundStyle(Color.vvGray)
    }
    
    private func bookingDetails() -> some View {
        VStack(alignment: .leading, spacing: Paddings.defaultPadding8) {
            Text(viewModel.claimBookingCheckDetails.bookingDetailTitle)
                .fontStyle(.headline)
            ForEach(viewModel.claimBookingCheckDetails.items.indices, id: \.self) { index in
                let detail = viewModel.claimBookingCheckDetails.items[index]
                Text(detail)
                    .fontStyle(.subheadline)
            }
        }
        .foregroundStyle(Color.vvGray)
    }
    
    private func buttons() -> some View {
        VStack(spacing: Paddings.defaultVerticalPadding24) {
            LoadingButton(title: viewModel.claimBookingCheckDetails.claimBookingButton, loading: false) {
                viewModel.next { result in
                    switch result {
                    case .successRequiresAuthentication:
                        viewModel.openRequiresAuthenticationView()
                    case .bookingNotFound:
                        viewModel.openBookingNotFound()
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
            
            Button(viewModel.claimBookingCheckDetails.cancelButton) {
                viewModel.navigateBack()
            }
            .buttonStyle(DismissServiceButtonStyle(foregroundColor: Color.vvGray))
        }
    }
}

#Preview {
    CheckBookingDetailsView()
}

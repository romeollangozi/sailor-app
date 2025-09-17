//
//  ClaimBookingMissingDetailsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.12.24.
//

import SwiftUI
import VVUIKit

struct ClaimBookingMissingDetailsView: View {
    
    @State private var viewModel: ClaimBookingMissingDetailsViewModelProtocol

    init(viewModel: ClaimBookingMissingDetailsViewModelProtocol = ClaimBookingMissingDetailsViewModel(dateOfBirthError: nil, dateOfBirth: DateComponents(), bookingReferenceNumber: "")) {

        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        toolbar
        VStack(spacing: Paddings.defaultVerticalPadding24) {
            header
            datePickerView
            Spacer()
            buttons
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
    }
    
    private var toolbar: some View {
        Toolbar(buttonStyle: .backButton) {
			viewModel.navigateBack()
		}
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding24) {
            Text(viewModel.missingDetailsTitle)
                .fontStyle(.largeCaption)
            Text(viewModel.missingDetailsDescription)
                .fontStyle(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var datePickerView: some View {
        DatePickerView(headerText: viewModel.dateOfBirthTitle,
                       selectedDateComponents: $viewModel.dateOfBirth,
                       error: viewModel.dateOfBirthError)
    }
    
    private var buttons: some View {
        VStack(spacing: Paddings.defaultVerticalPadding16) {
            Button(viewModel.next) {
                viewModel.openCheckDetailsScreen()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!viewModel.isValidDate())
            Button(viewModel.cancelText) {
                viewModel.cancel()
            }
            .buttonStyle(DismissServiceButtonStyle(foregroundColor: .darkGray))
        }
        .padding(.top, Paddings.defaultVerticalPadding16)
        .padding(.bottom, Paddings.defaultVerticalPadding40)
    }
}

#Preview {
    ClaimBookingMissingDetailsView()
}

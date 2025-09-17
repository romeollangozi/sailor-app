//
//  ClaimBookingNotFoundView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/11/24.
//

import SwiftUI
import VVUIKit

protocol ClaimBookingNotFoundViewModelProtocol  {
    func navigateBack()
    func navigateBackToRoot()
    func enterDetailsManuallyButtonTapped()
}

extension ClaimBookingNotFoundView {
    static func create() -> ClaimBookingNotFoundView {
        let viewModel = ClaimBookingNotFoundViewModel()
        return ClaimBookingNotFoundView(viewModel: viewModel)
    }
}

struct ClaimBookingNotFoundView: View {
    
    @State private var viewModel: ClaimBookingNotFoundViewModelProtocol

    init(viewModel: ClaimBookingNotFoundViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
		toolbar
        VStack(spacing: Spacing.space24) {
            header
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
            Text("Booking not found - check your booking details")
                .fontStyle(.largeTitle)
            Text("Check the details on your booking confirmation email.\n\nIf there are spelling mistakes or errors you can enter your details manually - exactly as they appear, then update them later by calling sailor services.")
                .fontStyle(.largeTagline)
                .foregroundColor(Color(hex: "#686D72"))
        }
    }
    
    private var callToActionButtons: some View {
        VStack(alignment: .center, spacing: Spacing.space16) {
            Button("Enter details manually") {
                viewModel.enterDetailsManuallyButtonTapped()
            }
            .buttonStyle(PrimaryButtonStyle())

            Button("Cancel") {
                viewModel.navigateBackToRoot()
            }
            .buttonStyle(TertiaryButtonStyle())
        }.padding(.top, Spacing.space16)
    }
}


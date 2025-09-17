//
//  ClaimBookingSuccessRequiresAuthenticationView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/4/24.
//

import SwiftUI

struct ClaimBookingSuccessRequiresAuthenticationView: View {

	@State var viewModel: ClaimBookingSuccessRequiresAuthenticationViewModel

	init(viewModel: ClaimBookingSuccessRequiresAuthenticationViewModel = ClaimBookingSuccessRequiresAuthenticationViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		VStack(spacing: 24.0) {
			header
			callToActionButtons
			Spacer()
		}
		.padding(.horizontal, 24.0)
	}

	private var header: some View {
		VStack(alignment: .leading, spacing: 24.0) {
			Text("Success, please log-in again")
				.fontStyle(.largeTitle)
			Text("We've found and connected your booking! Please log-out and in again so we can get this show on the seas.")
				.fontStyle(.largeTagline)
				.foregroundColor(Color(hex: "#686D72"))
		}
	}

	private var callToActionButtons: some View {
		VStack(alignment: .center, spacing: 16) {
			Button("Login") {
				viewModel.login()
			}
			.buttonStyle(PrimaryButtonStyle())
		}.padding(.top, 16.0)
	}
}


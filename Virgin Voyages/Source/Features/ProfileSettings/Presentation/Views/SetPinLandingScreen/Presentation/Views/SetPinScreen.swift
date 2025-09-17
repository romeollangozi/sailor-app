//
//  SetPinScreen.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.7.25.
//

import SwiftUI
import VVUIKit

protocol SetPinScreenViewModelProtocol {
	var labels: SetPinScreen.Labels { get }
	var isLoading: Bool { get }
	var isSaveButtonEnabled: Bool { get }
	var showError: Bool { get }
	func onBackButtonTap()
	func onChangePinButtonTap()
	func onSetPinValue(pin: String)
}

struct SetPinScreen: View {

	@State var viewModel: SetPinScreenViewModelProtocol

	init(viewModel: SetPinScreenViewModelProtocol = SetPinScreenViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}

    var body: some View {
		VStack {
			toolbar()
			ScrollView {
				VStack(spacing: Spacing.space24) {
					Text(viewModel.labels.title)
						.font(.vvHeading2Bold)
						.foregroundColor(.titleColor)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom)

					PinView { pin in
						viewModel.onSetPinValue(pin: pin)
					}

					if viewModel.showError {
						StatusCardView.warning(title: viewModel.labels.casinoEditErrorHeading,
											   body: viewModel.labels.casinoEditErrorBody)
					}

					LoadingButton(title: viewModel.labels.saveButtonTitle, loading: viewModel.isLoading) {
						viewModel.onChangePinButtonTap()
					}
					.buttonStyle(PrimaryButtonStyle())
					.disabled(!viewModel.isSaveButtonEnabled)

					Spacer()

				}
				.padding(Spacing.space24)

				Spacer(minLength: Spacing.space24)
			}
		}

    }

	private func toolbar() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space32) {
			BackButton {
				viewModel.onBackButtonTap()
			}
			.padding(.horizontal, Spacing.space24)
			.opacity(0.8)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.top, Spacing.space24)
	}
}

extension SetPinScreen {
	struct Labels {
		let title: String
		let saveButtonTitle: String
		let casinoEditErrorBody: String
		let casinoEditErrorHeading: String
	}
}

#Preview {
    SetPinScreen()
}

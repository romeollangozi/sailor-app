//
//  SetPinLandingScreen.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.7.25.
//

import SwiftUI
import VVUIKit

protocol SetPinLandingScreenViewModelProtocol {
	var labels: SetPinLandingScreen.Labels { get }
	var showSuccessMessage: Bool { get }
	func onBackButtonTap()
	func onChangePinButtonTap()
}

struct SetPinLandingScreen: View {

	@State var viewModel: SetPinLandingScreenViewModelProtocol
	
	init(viewModel: SetPinLandingScreenViewModelProtocol) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
			VStack {

				toolbar()

				ScrollView {
					if viewModel.showSuccessMessage {
						StatusCardView.success(title: viewModel.labels.successMessageTitle,
											   body: viewModel.labels.successMessageBody)
						.padding()
					}
					VStack(spacing: Spacing.space24) {

						titleText

						descriptionText

						saveButton

						Divider()
					}
					.padding(Spacing.space24)

					Spacer(minLength: Spacing.space24)
				}
			}
	}

	private var titleText: some View {
		Text(viewModel.labels.title)
			.font(.vvHeading2Bold)
			.foregroundColor(.titleColor)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.bottom)
	}

	private var descriptionText: some View {
		Text(viewModel.labels.subtitle)
			.font(.vvBody)
			.foregroundColor(.vvGray)
			.multilineTextAlignment(.leading)
			.padding(.bottom)
	}

	private var saveButton: some View {
		Button(action: {
			viewModel.onChangePinButtonTap()
		}) {
			HStack {
				VStack(alignment: .leading, spacing: Spacing.space24) {
					Text(viewModel.labels.changePinButton)
						.font(.vvBodyLight)
						.foregroundColor(.titleColor)
				}
				Spacer()
				Image(systemName: "arrow.right")
					.foregroundColor(.accentColor)
					.fontStyle(.lightTitle)
			}
			.contentShape(Rectangle())
		}
		.buttonStyle(PlainButtonStyle())
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

extension SetPinLandingScreen {
	struct Labels {
		let title: String
		let subtitle: String
		let changePinButton: String
		let successMessageTitle: String
		let successMessageBody: String
	}
}

#Preview {
	SetPinLandingScreen(viewModel: SetPinLandingScreenViewModel())
}

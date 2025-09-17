//
//  AddContactSheet.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.3.25.
//

import SwiftUI
import VVUIKit

protocol AddContactSheetViewModelProtocol {
	var deepLinkContactDataModel: DeepLinkContactDataModel { get }
	var allowAttending: Bool { get set }
	var screenState: ScreenState { get set }
	var addFriendButtonLoading: Bool { get set }
	func addFriend()
	func onAppear()
}

struct AddContactSheet: View {

	@State var viewModel: AddContactSheetViewModelProtocol

	let onDismiss: (() -> Void)

	init(contact: AddContactData, isFromDeepLink: Bool,  onDismiss: @escaping (() -> Void)) {
		_viewModel = State(wrappedValue: AddContactSheetViewModel(contact: contact, isFromDeepLink: isFromDeepLink, onDismiss: {
			onDismiss()
		}))
		self.onDismiss = onDismiss
	}

	var body: some View {
		VStack {
			toolbar()
			ScrollView {
				VStack(spacing: Spacing.space16) {
					contactInfoSection()
					Divider()
						.padding(.horizontal)
					allowAttendingView()
					descriptionSection()
					Spacer()
					addFriendButton()
				}
				.padding(.horizontal, Spacing.space24)
			}
		}
		.onAppear {
			viewModel.onAppear()
		}
	}

	private func toolbar() -> some View {
		Toolbar(buttonStyle: .closeButton) {
			onDismiss()
		}
	}

	private func contactInfoSection() -> some View {
		VStack {
			Text(viewModel.deepLinkContactDataModel.titleText)
				.font(.vvHeading3Bold)
				.padding([.top, .bottom], Spacing.space8)

			AuthURLImageView(imageUrl: viewModel.deepLinkContactDataModel.imageUrl,
							 size: Sizes.defaultSize150,
							 clipShape: .circle,
							 defaultImage: "ProfilePlaceholder")

			Text(viewModel.deepLinkContactDataModel.preferredName)
				.font(.vvHeading3Bold)
				.padding(.bottom, Spacing.space8)
		}
	}

	private func allowAttendingView() -> some View {
		HStack {
			Text(viewModel.deepLinkContactDataModel.allowAttending)
				.fontStyle(.body)
			Spacer()
			VVToggle(isOn: $viewModel.allowAttending)
		}
		.padding(.vertical, Spacing.space16)
	}

	private func descriptionSection() -> some View {
		Text(viewModel.deepLinkContactDataModel.description)
			.font(.vvSmallLight)
			.foregroundStyle(Color.vvGray)
			.padding(.bottom, Spacing.space24)
	}

	private func addFriendButton() -> some View {
		LoadingButton(title: viewModel.deepLinkContactDataModel.addFriendButtonText,
					  loading: viewModel.addFriendButtonLoading,
					  action: viewModel.addFriend)
			.primaryButtonStyle(isDisabled: viewModel.addFriendButtonLoading)
			.padding(.bottom, Spacing.space24)
	}
}

#Preview {
	AddContactSheet(contact: .init(reservationGuestId: "1f6db0d2-9590-406c-af4b-f146a0d64e80",
								   reservationId: "8f0ed440-fead-47ff-a041-ba69e2fc368e",
								   voyageNumber: "-ba69e2fc368e",
								   name: "Arber Limani"),
					isFromDeepLink: false,
					onDismiss: {})
}

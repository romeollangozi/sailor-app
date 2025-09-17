//
//  FriendAlreadyExistsSheet.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 12.9.25.
//

import SwiftUI
import VVUIKit

@MainActor
protocol FriendAlreadyExistsViewModelProtocol {
	var contact: AddContactData { get }
	var profileImageUrl: String { get }
	var labels: FriendAlreadyExistsSheet.Labels { get }
	func onAppear() async
}

struct FriendAlreadyExistsSheet: View {

	@State var viewModel: FriendAlreadyExistsViewModelProtocol

	let onClose: (() -> Void)

	init(contact: AddContactData, onClose: @escaping (() -> Void)) {
		_viewModel = State(wrappedValue: FriendAlreadyExistsViewModel(contact: contact))
		self.onClose = onClose
	}

	var body: some View {
		VStack(spacing: 0) {
			toolbar()

			contactInfoSection()
				.padding(.horizontal, Spacing.space24)

			Spacer()
			addFriendButton()
				.padding(.horizontal, Spacing.space24)
		}
		.frame(maxHeight: .infinity)
		.onAppear {
			Task {
				await viewModel.onAppear()
			}
		}
	}

	private func toolbar() -> some View {
		Toolbar(buttonStyle: .closeButton) {
			onClose()
		}
	}

	private func contactInfoSection() -> some View {
		VStack(spacing: Spacing.space16) {
			Text(viewModel.labels.title)
				.font(.vvHeading3Bold)
				.multilineTextAlignment(.center)
				.padding([.top, .bottom], Spacing.space8)
			Spacer()
			AuthURLImageView(imageUrl: viewModel.profileImageUrl,
						   size: Sizes.defaultSize150,
						   clipShape: .circle,
						   defaultImage: "ProfilePlaceholder")

			Text(viewModel.contact.name)
				.font(.vvHeading3Bold)
				.padding(.vertical, Spacing.space24)
			Spacer()
		}
		.padding(.top, Spacing.space24)
	}

	private func addFriendButton() -> some View {
		PrimaryButton(viewModel.labels.buttonText, action: {
			onClose()
		})
		.padding(.bottom, Spacing.space24)
	}
}

extension FriendAlreadyExistsSheet {
	struct Labels {
		let title: String
		let buttonText: String
	}
}

#Preview("Main Sheet - Long Name") {
	FriendAlreadyExistsSheet(
		contact: .init(
			reservationGuestId: "3g8ed2f4-b7a2-618e-ch6d-h368c2f86ga2",
			reservationId: "ah2gf662-hfcg-69hh-c263-dc8bg4he58ag",
			voyageNumber: "-dc8bg4he58ag",
			name: "Christina Elizabeth Martinez-Rodriguez"
		),
		onClose: { }
	)
}

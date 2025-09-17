//
//  DeepLinkContactDataUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.3.25.
//

protocol DeepLinkContactDataUseCaseProtocol {
	func execute() -> DeepLinkContactDataModel?
}

struct DeepLinkContactDataUseCase: DeepLinkContactDataUseCaseProtocol {

	private let contact: AddContactData
	private let isFromDeepLink: Bool
	private let localizationManager: LocalizationManagerProtocol

	init(contact: AddContactData, isFromDeepLink: Bool = false, localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
		self.contact = contact
		self.isFromDeepLink = isFromDeepLink
		self.localizationManager = localizationManager
	}

	func execute() -> DeepLinkContactDataModel? {
		let title = isFromDeepLink ? localizationManager.getString(for: .deeplinkAddFriendTitle) : localizationManager.getString(for: .contactsScanFoundFriendTitle)
		let allowAttending = localizationManager.getString(for: .deeplinkAddFriendAllowAttending).replacingPlaceholder("name", with: contact.name)
		let description = localizationManager.getString(for: .deeplinkAddFriendDescription)
		let button = localizationManager.getString(for: .deeplinkAddFriendButton)

		return DeepLinkContactDataModel(
			titleText: title,
			imageUrl: "no name",
			preferredName: contact.name,
			allowAttending: allowAttending,
			description: description,
			addFriendButtonText: button,
			connectionReservationId: contact.reservationId,
			connectionReservationGuestId: contact.reservationGuestId
		)
	}

}

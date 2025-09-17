//
//  DeepLinkContactDataModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.3.25.
//

struct DeepLinkContactDataModel {
	let titleText: String
	let imageUrl: String
	let preferredName: String
	let allowAttending: String
	let description: String
	let addFriendButtonText: String
	let connectionReservationId: String
	let connectionReservationGuestId: String

	static func empty() -> DeepLinkContactDataModel {
		return DeepLinkContactDataModel(
			titleText: "",
			imageUrl: "",
			preferredName: "",
			allowAttending: "",
			description: "",
			addFriendButtonText: "",
			connectionReservationId: "",
			connectionReservationGuestId: ""
		)
	}
	
	static func mock() -> DeepLinkContactDataModel {
		return DeepLinkContactDataModel(
			titleText: "Accept invite, and add friend?",
			imageUrl: "https://media.licdn.com/dms/image/v2/C4D03AQFtKL3--O-F4Q/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1516812285029?e=1746662400&v=beta&t=nmychaEJCxel7y-rR4w5_MlW8XasCsERqhk3vupnYTc",
			preferredName: "John Doe",
			allowAttending: "Allow John Doe to see what I’m attending",
			description: "Adding a friend will also add their cabin-mates so you can all message and book activities together. You can manage your contacts in your contacts list.",
			addFriendButtonText: "Add Friend",
			connectionReservationId: "RES12345",
			connectionReservationGuestId: "GUEST67890"
		)
	}
}

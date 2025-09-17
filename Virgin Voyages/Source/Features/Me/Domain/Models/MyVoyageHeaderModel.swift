//
//  MyVoyageHeaderModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 5.3.25.
//

import Foundation

struct MyVoyageHeaderModel: Equatable {
    let imageUrl: String
    let type: MyVoyageType
    let name: String
    let profileImageUrl: String
    let cabinNumber: String
    let lineUpOpeningDateTime: String
    let isLineUpOpened: Bool
    let buttonSettingsTitle: String
    let buttonMyWalletTitle: String
    let buttonLineUpTitle: String
	let buttonAddonsTitle: String
    let emptyStateText: String
    let tabMyAgendaTitle: String
    let tabAddOnsTitle: String
}

extension MyVoyageHeaderModel {
    static func empty() -> MyVoyageHeaderModel {
        return MyVoyageHeaderModel(
            imageUrl: "",
            type: .standard,
            name: "",
            profileImageUrl: "",
            cabinNumber: "",
            lineUpOpeningDateTime: "",
            isLineUpOpened: false,
            buttonSettingsTitle: "",
            buttonMyWalletTitle: "",
            buttonLineUpTitle: "",
			buttonAddonsTitle: "",
            emptyStateText: "",
            tabMyAgendaTitle: "",
            tabAddOnsTitle: ""
        )
    }

	static func sample() -> MyVoyageHeaderModel {
		return MyVoyageHeaderModel(
			imageUrl: "https://example.com/header.jpg",
			type: .rockStar,
			name: "Sailor name",
			profileImageUrl: "https://example.com/profile.jpg",
			cabinNumber: "101A",
			lineUpOpeningDateTime: "2025-06-01T17:00:00Z",
			isLineUpOpened: true,
			buttonSettingsTitle: "Settings",
			buttonMyWalletTitle: "Wallet",
			buttonLineUpTitle: "View Line-Up",
			buttonAddonsTitle: "Explore Add-ons",
			emptyStateText: "No items booked yet.",
			tabMyAgendaTitle: "My Agenda",
			tabAddOnsTitle: "Add-ons"
		)
	}
}

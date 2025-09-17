//
//  ProfileSettingsMenuListItemModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import Foundation

struct ProfileSettingsMenuListItemModel: Identifiable, Hashable {
    let id: ProfileSettingItemIdentifier
    let title: String
    let description: String
    let isEnabled: Bool
    let sequence: Int
    
    init(id: ProfileSettingItemIdentifier, title: String, description: String = "", isEnabled: Bool = true, sequence: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
        self.sequence = sequence
    }
}

enum ProfileSettingItemIdentifier : String {
	case personalInformation = "personalInformation"
	case contactDetails = "contactDetails"
	case paymentCard = "paymentCard"
	case switchVoyage = "switchVoyage"
	case termsAndConditions = "termsAndConditions"
	case commsAndMarketing = "commsAndMarketing"
	case setCasinoPin = "setCasinoPin"
	case undefined = "undefined"
}

extension ProfileSettingsMenuListItemModel {
	static func sample() -> ProfileSettingsMenuListItemModel {
		return ProfileSettingsMenuListItemModel(
			id: .personalInformation,
			title: "Sample Menu Item",
			description: "Sample Description",
			isEnabled: true,
			sequence: 1
		)
	}
}

extension ProfileSettingsMenuListItemModel {
	func copy(
		id: ProfileSettingItemIdentifier? = nil,
		title: String? = nil,
		description: String? = nil,
		isEnabled: Bool? = nil,
		sequence: Int? = nil
	) -> ProfileSettingsMenuListItemModel {
		return ProfileSettingsMenuListItemModel(
			id: id ?? self.id,
			title: title ?? self.title,
			description: description ?? self.description,
			isEnabled: isEnabled ?? self.isEnabled,
			sequence: sequence ?? self.sequence
		)
	}
}

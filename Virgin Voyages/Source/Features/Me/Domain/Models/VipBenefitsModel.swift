//
//  VipBenefitsModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

struct VipBenefitsModel {
	let benefits: [VipBenefits.Benefit]
	let supportEmailAddress: String
	let title: String
	let subtitle: String
	let contactTitle: String
	let contactImage: String
	let sailorLocation: SailorLocation

	static func empty() -> VipBenefitsModel {
		return VipBenefitsModel(
			benefits: [],
			supportEmailAddress: "",
			title: "",
			subtitle: "",
			contactTitle: "",
			contactImage: "",
			sailorLocation: .shore
		)
	}

	static func mock() -> VipBenefitsModel {
		return VipBenefitsModel(
			benefits: [
				VipBenefits.Benefit(sequence: "1", iconUrl: "https://example.com/icon1.png", summary: "Exclusive Access to VIP Lounge"),
				VipBenefits.Benefit(sequence: "2", iconUrl: "https://example.com/icon2.png", summary: "Early Bird Booking for Events")
			],
			supportEmailAddress: "support@virginvoyages.com",
			title: "VIP Benefits",
			subtitle: "Exclusive VIP Access",
			contactTitle: "Contact your Rockstar Agent",
			contactImage: "Messenger",
			sailorLocation: .shore
		)
	}
}

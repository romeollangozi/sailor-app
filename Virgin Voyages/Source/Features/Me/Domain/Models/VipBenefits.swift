//
//  VipBenefits.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

struct VipBenefits {
	struct Benefit: Hashable {
		let sequence: String
		let iconUrl: String
		let summary: String
	}

	let benefits: [Benefit]
	let supportEmailAddress: String

	static func empty() -> VipBenefits {
		return VipBenefits(
			benefits: [],
			supportEmailAddress: ""
		)
	}

	static func mock() -> VipBenefits {
		return VipBenefits(
			benefits: [
				Benefit(sequence: "1", iconUrl: "https://example.com/icon1.png", summary: "Exclusive Access to VIP Lounge"),
				Benefit(sequence: "2", iconUrl: "https://example.com/icon2.png", summary: "Early Bird Booking for Events")
			],
			supportEmailAddress: "support@virginvoyages.com"
		)
	}
}

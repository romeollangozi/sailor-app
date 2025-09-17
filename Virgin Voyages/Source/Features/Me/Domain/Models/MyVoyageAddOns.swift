//
//  MyVoyageAddOns.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

import Foundation

struct MyVoyageAddOns {
	let addOns: [Addon]
	let emptyStatePictogramUrl: String
	let emptyStateText: String
	let title: String

	struct Addon {
		let uuid: UUID = UUID()
		let id: String
		let imageUrl: String
		let name: String
		let description: String
		let isViewable: Bool
	}
}

extension MyVoyageAddOns {

	static func empty() -> MyVoyageAddOns {
		return MyVoyageAddOns(
			addOns: [],
			emptyStatePictogramUrl: "",
			emptyStateText: "",
			title: ""
		)
	}

	static func sample() -> MyVoyageAddOns {
		return MyVoyageAddOns(
			addOns: [
				Addon(
					id: "1",
					imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:dfc86261-5dc1-4c59-9efe-30bc3554f0ba/ILL-DEST-premium-wifi-hand-v1-01-417x417.png",
					name: "Spa Package",
					description: "Relax and rejuvenate with our exclusive spa package.",
					isViewable: true
				),
				Addon(
					id: "2",
					imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:31066c8b-81e5-4f40-8891-236d7f3bd2ab/DEEP%20BLUE%20EXTRAS.svg",
					name: "Excursion Tour",
					description: "Explore the city with a guided tour.",
					isViewable: true
				),
				Addon(
					id: "3",
					imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7617f2f1-0333-447a-bea1-268b877ed769/emptylist_addons_128x128.png",
					name: "Special Dinner",
					description: "Enjoy a gourmet dinner with a view.",
					isViewable: true
				)
			],
			emptyStatePictogramUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7617f2f1-0333-447a-bea1-268b877ed769/emptylist_addons_128x128.png",
			emptyStateText: "No add-ons available at the moment.",
			title: "Available Add-ons"
		)
	}
}

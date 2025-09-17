//
//  ShoreThingsList.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

struct ShoreThingsList {
	let types: [ShoreThingsListType]
	let items: [ShoreThingItem]
	let title: String
	let description: String
}

extension ShoreThingsList {
	static func sample() -> ShoreThingsList {
		.init(types: [
			.init(code: "ONCE IN A LIFE", name: "Once in a Lifetime"),
			.init(code: "ENERGETIC", name: "Energetic"),
			.init(code: "RELAXING", name: "Relaxing"),
			.init(code: "DARING", name: "Daring"),
			.init(code: "CULTURED", name: "Cultured"),
			.init(code: "RICHARD'S LIST", name: "Richard's Faves"),
			.init(code: "EXCLUSIVES", name: "Exclusives")
		],
			  items: [.sample()],
			  title: "Far more than just a home port",
			  description: "From the art scene in Wynwood to the shores of Miami Beach, Florida&#39;s Magic City is a perfect collision of relaxation and tradition.")
	}
}

extension ShoreThingsList {
	static func samplewithMultipleExcursions() -> ShoreThingsList {
		.init(types: [
			.init(code: "ONCE IN A LIFE", name: "Once in a Lifetime"),
			.init(code: "ENERGETIC", name: "Energetic"),
			.init(code: "RELAXING", name: "Relaxing"),
			.init(code: "DARING", name: "Daring"),
			.init(code: "CULTURED", name: "Cultured"),
			.init(code: "RICHARD'S LIST", name: "Richard's Faves"),
			.init(code: "EXCLUSIVES", name: "Exclusives")
		],
			  items: [
				.sample()
				.copy(
					id: "1",
					name: "Bimini Beach Cabana",
					imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:950edbf6-a1ce-468a-8f61-58bcbacc8a27/VV.com%20-%20Bimini%20Beach%20Cabana%20-%201200x800.png",
					price: 650,
					priceFormatted: "$650.00",
					types: ["RELAXING"],
					tourDifferentiators: []
				),
				.sample()
				.copy(id: "2",
					  name: "Bimini Lagoon Cabana",
					  imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:1557a788-a251-4cc7-8702-c106334cc9e1/IMG-DEST-BIMINI-BAHAMAS-Bimini-Lagoon-Cabana-Shore-Thing-Module-Card-Hero-1200x800.jpg",
					  price: 350,
					  priceFormatted: "$650.00",
					  duration: "9 mins",
					  types: ["CULTURED"])
			  ],
			  title: "Those Bimini blues",
			  description: "Besides having access to the island&rsquo;s incredible biodiversity and historic shipwreck diving, you can also snag a cabana at Virgin Voyages Beach Club at Bimini.")
	}
}

extension ShoreThingsList {
	func copy(
		types:  [ShoreThingsListType]? = nil,
		items: [ShoreThingItem]? = nil,
		title: String? = nil,
		description: String? = nil
	) -> ShoreThingsList {
		return .init(types: types ?? self.types,
					 items: items ?? self.items,
					 title: title ?? self.title,
					 description: description ?? self.description)
	}
}

extension ShoreThingsList {
	static func empty() -> ShoreThingsList {
		return .init(types: [], items: [],title: "", description: "")
	}
}


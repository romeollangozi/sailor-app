//
//  EateriesList.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 23.11.24.
//

import Foundation

struct EateriesList: Equatable {
	struct Eatery : Equatable {
		let id: String = UUID().uuidString
		let name: String
		let slug: String
		let externalId: String
		let squareThumbnailUrl: String?
		let subHeading: String
		let venueId: String
		let isBookable: Bool
		
		init(name: String, slug: String, externalId: String, squareThumbnailUrl: String?, subHeading: String, venueId: String, isBookable: Bool) {
			self.name = name
			self.slug = slug
			self.externalId = externalId
			self.squareThumbnailUrl = squareThumbnailUrl
			self.subHeading = subHeading
			self.venueId = venueId
			self.isBookable = isBookable
		}
		
		static func == (lhs: Eatery, rhs: Eatery) -> Bool {
			return lhs.externalId == rhs.externalId && lhs.venueId == rhs.venueId
		}
	}
	
	let bookable: [Eatery]
	let walkIns: [Eatery]
	let guestCount: Int
	let leadTime: EateryLeadTime?
	let preVoyageBookingStoppedInfo: EateryPreVoyageBookingStoppedInfo?
	var isPreVoyageBookingStopped: Bool {
		return preVoyageBookingStoppedInfo != nil || leadTime != nil
	}
    var resources: EateryLocalizationResources = .empty()
}

extension EateriesList {
	func findBookableEatery(byExternalId externalId: String) -> Eatery? {
		if let eatery = bookable.first(where: { $0.externalId == externalId }) {
			return eatery
		}
		
		return nil
	}
	
	func findEatery(byExternalId externalId: String) -> Eatery? {
		if let eatery = (bookable + walkIns).first(where: { $0.externalId == externalId }) {
			return eatery
		}
		
		return nil
	}
}

extension EateriesList {
	func findBookables(externalIds: [String]) -> [Eatery] {
		return bookable.filter { externalIds.contains($0.externalId) }
	}
}

extension EateriesList {
	static func sample() -> EateriesList {
		return EateriesList(
			bookable: [
				Eatery(
					name: "Razzle Dazzle Restaurant",
					slug: "razzle-dazzle-restaurant",
					externalId: "5a4bf485da0c112a66ed6217",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
					subHeading: "Signature restaurant | Deck 5 Mid",
					venueId: "8dcb59d6-fd6e-4500-b592-dd49f6ddca6e",
					isBookable: true
				),
				Eatery(
					name: "The Test Kitchen",
					slug: "The-Test-Kitchen",
					externalId: "5a4bf485da0c112a66ed6263",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
					subHeading: "Experimental onboard eatery | Deck 5 Mid",
					venueId: "1dbce3e9-914a-4a05-bcf6-31f75434c362",
					isBookable: true
				)
			],
			walkIns: [
				Eatery(
					name: "Well Bread",
					slug: "well-bread",
					externalId: "5e22e26edf73db6837788a4e",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:baffe31b-3f13-4b48-b90a-9ed52ad1c24c/RDR-FNB-the-galley-well-bread-20181106-120x120.jpg",
					subHeading: "Pastries and Flatbreads | Deck 15 Mid-Aft",
					venueId: "5e22e26edf73db6837788a4e",
					isBookable: false
				)
			],
			guestCount: 2,
			leadTime: nil,
			preVoyageBookingStoppedInfo: nil
		)
	}
}

extension EateriesList {
	static func sampleWithLeadTime() -> EateriesList {
		return EateriesList(
			bookable: [
				Eatery(
					name: "Razzle Dazzle Restaurant",
					slug: "razzle-dazzle-restaurant",
					externalId: "5a4bf485da0c112a66ed6217",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
					subHeading: "Signature restaurant | Deck 5 Mid",
					venueId: "8dcb59d6-fd6e-4500-b592-dd49f6ddca6e",
					isBookable: true
				),
				Eatery(
					name: "The Test Kitchen",
					slug: "The-Test-Kitchen",
					externalId: "5a4bf485da0c112a66ed6263",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
					subHeading: "Experimental onboard eatery | Deck 5 Mid",
					venueId: "1dbce3e9-914a-4a05-bcf6-31f75434c362",
					isBookable: true
				)
			],
			walkIns: [
				Eatery(
					name: "Well Bread",
					slug: "well-bread",
					externalId: "5e22e26edf73db6837788a4e",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:baffe31b-3f13-4b48-b90a-9ed52ad1c24c/RDR-FNB-the-galley-well-bread-20181106-120x120.jpg",
					subHeading: "Pastries and Flatbreads | Deck 15 Mid-Aft",
					venueId: "5e22e26edf73db6837788a4e",
					isBookable: false
				)
			],
			guestCount: 2,
			leadTime: EateryLeadTime(title: "Booking opens:",
									 subtitle: "9am EST Feb 10th, 2024",
									 description: "Pop back then to make your reservations.",
									 date: Date(),
									 upgradeClassUrl: "",
									 isCountdownStarted: false),
			preVoyageBookingStoppedInfo: nil
		)
	}
}

extension EateriesList {
	static func sampleWithPreVoyageBookingStoppedInfo() -> EateriesList {
		return EateriesList(
			bookable: [
				Eatery(
					name: "Razzle Dazzle Restaurant",
					slug: "razzle-dazzle-restaurant",
					externalId: "5a4bf485da0c112a66ed6217",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
					subHeading: "Signature restaurant | Deck 5 Mid",
					venueId: "8dcb59d6-fd6e-4500-b592-dd49f6ddca6e",
					isBookable: true
				),
				Eatery(
					name: "The Test Kitchen",
					slug: "The-Test-Kitchen",
					externalId: "5a4bf485da0c112a66ed6263",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
					subHeading: "Experimental onboard eatery | Deck 5 Mid",
					venueId: "1dbce3e9-914a-4a05-bcf6-31f75434c362",
					isBookable: true
				)
			],
			walkIns: [
				Eatery(
					name: "Well Bread",
					slug: "well-bread",
					externalId: "5e22e26edf73db6837788a4e",
					squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:baffe31b-3f13-4b48-b90a-9ed52ad1c24c/RDR-FNB-the-galley-well-bread-20181106-120x120.jpg",
					subHeading: "Pastries and Flatbreads | Deck 15 Mid-Aft",
					venueId: "5e22e26edf73db6837788a4e",
					isBookable: false
				)
			],
			guestCount: 2,
			leadTime: nil,
			preVoyageBookingStoppedInfo: .init(title: "We’re moving bookings and bags", description: "Our bookings are moving onto ship and will re-open on the Sailor App once you are on board.")
		)
	}
}

extension EateriesList {
	static func empty() -> EateriesList {
		return EateriesList(
			bookable: [],
			walkIns: [],
			guestCount: 2,
			leadTime: nil,
			preVoyageBookingStoppedInfo: nil
		)
	}
}

extension EateriesList {
	func copy(
		bookable: [Eatery]? = nil,
		walkIns: [Eatery]? = nil,
		guestCount: Int? = nil,
		isPreVoyageBookingStopped: Bool? = nil,
		leadTime: EateryLeadTime? = nil,
		preVoyageBookingStoppedInfo: EateryPreVoyageBookingStoppedInfo? = nil
	) -> EateriesList {
		return EateriesList(
			bookable: bookable ?? self.bookable,
			walkIns: walkIns ?? self.walkIns,
			guestCount: guestCount ?? self.guestCount,
			leadTime: leadTime ?? self.leadTime,
			preVoyageBookingStoppedInfo: preVoyageBookingStoppedInfo ?? self.preVoyageBookingStoppedInfo
		)
	}
}

extension EateriesList.Eatery {
	static func sample() -> EateriesList.Eatery {
		return EateriesList.Eatery(
			name: "Razzle Dazzle Restaurant",
			slug: "razzle-dazzle-restaurant",
			externalId: "5a4bf485da0c112a66ed6217",
			squareThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
			subHeading: "Signature restaurant | Deck 5 Mid",
			venueId: "8dcb59d6-fd6e-4500-b592-dd49f6ddca6e",
			isBookable: true
		)
	}
}

extension EateriesList.Eatery {
	func copy(
		name: String? = nil,
		slug: String? = nil,
		externalId: String? = nil,
		squareThumbnailUrl: String? = nil,
		subHeading: String? = nil,
		venueId: String? = nil,
		isBookable: Bool? = nil
	) -> EateriesList.Eatery {
		return EateriesList.Eatery(
			name: name ?? self.name,
			slug: slug ?? self.slug,
			externalId: externalId ?? self.externalId,
			squareThumbnailUrl: squareThumbnailUrl ?? self.squareThumbnailUrl,
			subHeading: subHeading ?? self.subHeading,
			venueId: venueId ?? self.venueId,
			isBookable: isBookable ?? self.isBookable
		)
	}
}

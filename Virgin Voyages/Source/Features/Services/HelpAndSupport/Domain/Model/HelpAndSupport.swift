//
//  HelpAndSupport.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

import Foundation

struct HelpAndSupport: Equatable {
	let supportEmailAddress: String
	let supportPhoneNumber: String
	let categories: [Category]
	let sailorServiceLocation: String
	
	struct Category: Equatable {
		let cta: String
		let sequenceNumber: String
		let name: String
		let articles: [Article]
	}
	
    struct Article: Hashable {
		let id: String = UUID().uuidString
		let name: String
		let body: String
		let categoryName: String
		let supportPhoneNumber: String
		let sailorServiceLocation: String
	}
}

extension HelpAndSupport {
	static func sample() -> HelpAndSupport {
		return HelpAndSupport(
			supportEmailAddress: "sailorservices@decurtis.com",
			supportPhoneNumber: "+1 954 488 2955",
			categories: [
				Category(
					cta: "Before You Sail",
					sequenceNumber: "1",
					name: "Have a question you need answered before getting on the ship? Browse here.",
					articles: [
						Article(
							name: "What documents do I need to board?",
							body: "You will need a valid passport and your boarding pass. Please ensure your travel documents are up to date.",
							categoryName: "Before You Sail",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Can I bring my own alcohol onboard?",
							body: "Guests are not permitted to bring their own alcohol onboard. However, a selection of beverages is available for purchase.",
							categoryName: "Before You Sail",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "What is the luggage policy?",
							body: "Each guest is allowed two pieces of luggage, with a maximum weight of 50 lbs per bag.",
							categoryName: "Before You Sail",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Are there any health requirements before sailing?",
							body: "Guests must complete a health questionnaire prior to boarding. Additional requirements may apply based on current health guidelines.",
							categoryName: "Before You Sail",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						)
					]
				),
				Category(
					cta: "The Days at Sea",
					sequenceNumber: "2",
					name: "Everything you need to know about your time on the ship and at each destination is here.",
					articles: [
						Article(
							name: "What voltage is used in the cabins?",
							body: "All of our cabins and suites have North American standard 110 volt AC and European standard 220 volt AC outlets.",
							categoryName: "The Days at Sea",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Is there a safe in my cabin?",
							body: "Yes, all cabins are equipped with a safe for the protection of your valuables. Big enough to hold a 17\" laptop.",
							categoryName: "The Days at Sea",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Are there irons and boards in the cabins?",
							body: "While irons and boards are not set up in our cabins, we do offer steamers on special request.",
							categoryName: "The Days at Sea",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Can I decorate my cabin door?",
							body: "We think our lady ships look fabulous as they are, and door decorations inevitably lead to unsightly damage.",
							categoryName: "The Days at Sea",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Is it possible to have a private party in my stateroom with snacks and drinks served?",
							body: "If you're staying in one of our Mega RockStar Quarters, you can make arrangements through your RockStar Agent. Snacks and drinks can be ordered through ShipEats.",
							categoryName: "The Days at Sea",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						),
						Article(
							name: "Where can I store medication that needs to be refrigerated?",
							body: "Our mini bars and in-room bars in our Suites have plenty of space. If you find yourself in need of extra space or specific temperature control, please contact Sailor Services, and they will accommodate your request as best they can.",
							categoryName: "The Days at Sea",
							supportPhoneNumber: "+1 954 488 2955",
							sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
						)
					]
				),
				Category(
					cta: "Back on Dry Land",
					sequenceNumber: "3",
					name: "If you’ve already sailed but have questions about your voyage, the answer you’re looking for is likely here.",
					articles: []
				)
			],
			sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
		)
	}
	
	static func sampleWithEmptyCategories() -> HelpAndSupport {
		return HelpAndSupport(
			supportEmailAddress: "sailorservices@decurtis.com",
			supportPhoneNumber: "+1 954 488 2955",
			categories: [],
			sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
		)
	}
}

extension HelpAndSupport {
	static func empty() -> HelpAndSupport {
		return HelpAndSupport(
			supportEmailAddress: "",
			supportPhoneNumber: "",
			categories: [],
			sailorServiceLocation: ""
		)
	}
}

extension HelpAndSupport {
	func copy(
		supportEmailAddress: String? = nil,
		supportPhoneNumber: String? = nil,
		categories: [Category]? = nil,
		sailorServiceLocation: String? = nil
	) -> HelpAndSupport {
		return HelpAndSupport(
			supportEmailAddress: supportEmailAddress ?? self.supportEmailAddress,
			supportPhoneNumber: supportPhoneNumber ?? self.supportPhoneNumber,
			categories: categories ?? self.categories,
			sailorServiceLocation: sailorServiceLocation ?? self.sailorServiceLocation
		)
	}
}

extension HelpAndSupport.Article {
	static func sample() -> HelpAndSupport.Article {
		return HelpAndSupport.Article(
			name: "Can I bring my own alcohol onboard?",
			body: "Guests are not permitted to bring their own alcohol onboard. However, a selection of beverages is available for purchase.",
			categoryName: "Before You Sail",
			supportPhoneNumber: "+1 954 488 2955",
			sailorServiceLocation: "Sailor Services, Deck 5 Mid-Aft"
		)
	}
}

extension HelpAndSupport.Article {
	static func empty() -> HelpAndSupport.Article {
		return HelpAndSupport.Article(
			name: "",
			body: "",
			categoryName: "",
			supportPhoneNumber: "",
			sailorServiceLocation: ""
		)
	}
}

extension HelpAndSupport.Article {
	func copy(
		id: String? = nil,
		name: String? = nil,
		body: String? = nil,
		categoryName: String? = nil,
		supportPhoneNumber: String? = nil,
		sailorServiceLocation: String? = nil
	) -> HelpAndSupport.Article {
		return HelpAndSupport.Article(
			name: name ?? self.name,
			body: body ?? self.body,
			categoryName: categoryName ?? self.categoryName,
			supportPhoneNumber: supportPhoneNumber ?? self.supportPhoneNumber,
			sailorServiceLocation: sailorServiceLocation ?? self.sailorServiceLocation
		)
	}
}

extension HelpAndSupport.Category {
	func copy(
		cta: String? = nil,
		sequenceNumber: String? = nil,
		name: String? = nil,
		articles: [HelpAndSupport.Article]? = nil
	) -> HelpAndSupport.Category {
		return HelpAndSupport.Category(
			cta: cta ?? self.cta,
			sequenceNumber: sequenceNumber ?? self.sequenceNumber,
			name: name ?? self.name,
			articles: articles ?? self.articles
		)
	}
}

extension HelpAndSupport.Category {
	static func sample() -> HelpAndSupport.Category {
		return HelpAndSupport.Category(
			cta: "Sample CTA",
			sequenceNumber: "1",
			name: "Sample Category",
			articles: [
				HelpAndSupport.Article.sample(),
			]
		)
	}
}

extension Array where Element == HelpAndSupport.Category {
	func withArticles(searchString: String? = nil, categoryId: String? = nil) -> [HelpAndSupport.Category] {
		var filtered: [HelpAndSupport.Category] = []

		for category in self {
			if categoryId != nil && !categoryId!.isEmpty && category.sequenceNumber != categoryId {
				continue
			}
			
			let filteredArticles = searchString != nil && !searchString!.isEmpty ? category.articles.filter {
				$0.name.localizedCaseInsensitiveContains(searchString!)
			} : category.articles
			
			if filteredArticles.count > 0 {
				filtered.append(category.copy(articles: filteredArticles))
			}
		}

		return filtered
	}
}

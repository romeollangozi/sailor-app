//
//  GetHelpAndSupportResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

extension GetHelpAndSupportResponse {
	func toDomain() -> HelpAndSupport {
		return HelpAndSupport(
			supportEmailAddress: self.supportEmailAddress.value,
			supportPhoneNumber: self.supportPhoneNumber.value,
			categories: self.categories?.map { category in
				HelpAndSupport.Category(
					cta: category.cta.value,
					sequenceNumber: category.sequenceNumber.value,
					name: category.name.value,
					articles: category.articles?.map { article in
						HelpAndSupport.Article(
							name: article.name.value,
							body: article.body.value,
							categoryName: category.cta.value,
							supportPhoneNumber: self.supportPhoneNumber.value,
							sailorServiceLocation: "\(self.name.value), \(self.deckLocation.value)"
						)
					} ?? []
				)
			} ?? [],
			sailorServiceLocation: "\(self.name.value), \(self.deckLocation.value)"
		)
	}
}

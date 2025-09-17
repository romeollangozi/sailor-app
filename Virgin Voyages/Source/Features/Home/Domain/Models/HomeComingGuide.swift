//
//  HomeComingGuide.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import Foundation

struct HomeComingGuide: Equatable, Hashable {
    let header: HomeComingGuideHeader
    let sections: [HomeComingGuideSection]

    struct HomeComingGuideHeader: Equatable, Hashable {
        let title: String
        let description: String
        let bannerImageUrl: String
        let deck: String
        let time: String
        let queueDescription: String

        static func empty() -> HomeComingGuideHeader {
            .init(
                title: "",
                description: "",
                bannerImageUrl: "",
                deck: "",
                time: "",
                queueDescription: ""
            )
        }

        static func sample() -> HomeComingGuideHeader {
            .init(
                title: "Homecoming",
                description: "Shake a leg and grab your bags — you need to be shoreside by 10:30am.",
                bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:93772c0a-68bb-482e-ab1b-bd59ff5ecb56/ILL-homecoming-guide-woman-hero-654x416.jpg",
                deck: "Deck 6",
                time: "9:30–10:30am",
                queueDescription: "Wanna miss the queues? Go early, and you’ll be back on dry land before you know it."
            )
        }
    }

	struct HomeComingGuideSection: Equatable, Hashable, Identifiable {
		var id: String = UUID().uuidString
        let title: String
        let subtitle: String?
        let description: String
        let bannerImageUrl: String?

        static func empty() -> HomeComingGuideSection {
            .init(
                title: "",
                subtitle: nil,
                description: "",
                bannerImageUrl: nil
            )
        }

        static func sample() -> HomeComingGuideSection {
            .init(
                title: "All packed and ready to go?",
                subtitle: nil,
                description: "Grab your bags and make your way to Deck 6 from 9:30am. If you need help with your luggage, please leave it outside your cabin by 10 PM with a bag tag attached.",
                bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:4d542ca8-64dc-431e-af00-a0248bcb96c1/ILL-homecoming-guide-luggage-form-634x282.jpg"
            )
        }
		
		static func samples () -> [HomeComingGuideSection] {
			[
				.init(title: "Welcome to the World!", subtitle: nil, description: "Welcome to the World!", bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:4d542ca8-64dc-431e-af00-a0248bcb96c1/ILL-homecoming-guide-luggage-form-634x282.jpg"),
				.init(title: "Where’s open for breakfast?", subtitle: nil, description: "Brunch will be available at Razzle Dazzle or The Wake. The Galley will be open until 10:15am. In a rush? Check out Grounds Club or Sip.", bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:ccb93ee3-cf14-4f0f-90a9-5eb2aba4f64b/ILL-homecoming-guide-breakfast-hero-654x416.jpg"),
				.init(title: "Sail on, Sailor!", subtitle: nil, description: "Get your fellow Sailors together and hail a ride — port-side. You can call a ride share or reach out to a local taxi from the arrival port.", bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:02c46f51-54ec-48b4-a207-07d277e7ea79/ILL-homecoming-guide-public-transportation-hero-654x416.jpg"),
				.init(title: "Immigration need-to-knows", subtitle: "<p><strong>Be souvenir savvy:</strong> You can bring back up to $800 of souvenirs, including the first liter of alcohol, first 100 cigars and 200 cigarettes, duty-free.</p>\n", description: "You can bring back up to $800 of souvenirs, including the first liter of alcohol, first 10 0 cigars and 200 cigarettes, duty-free.", bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:abf57e1b-9455-4fa8-a528-e79c33285121/ILL-homecoming-guide-immigration-hero-654x416.jpg"),
				.init(title: "Billing information", subtitle: nil, description: "View your voyage transactions to see a record of your spends.", bannerImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:bb8e56a3-6af9-4039-b943-1d605227a379/ILL-homecoming-guide-billing-hero-654x416.jpg")
			]
		}
    }
}
extension HomeComingGuide {
    static func empty() -> HomeComingGuide {
        .init(header: HomeComingGuideHeader.empty(), sections: [HomeComingGuideSection.empty()])
    }

    static func sample() -> HomeComingGuide {
        .init(header: HomeComingGuideHeader.sample(), sections: HomeComingGuideSection.samples())
    }
}

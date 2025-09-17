//
//  HomeAddOnsPromoSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 18.3.25.
//

import Foundation

struct HomeAddOnsPromoSection: HomeSection, Equatable {
    var id: String
    var key: SectionKey = .addOnsPromo
    var title: String
    let description: String
    let imageUrl: String
}

extension HomeAddOnsPromoSection {
    static func empty() -> Self {
        return HomeAddOnsPromoSection(
            id: UUID().uuidString,
            title: "",
            description: "",
            imageUrl: ""
        )
    }
        
    static func sample() -> Self {
        return HomeAddOnsPromoSection(
            id: UUID().uuidString,
            title: "Purchase Add-ons such as Bar Tab or WiFi upgrades",
            description: "View all Add-ons",
            imageUrl: "https://example.com/line-up.jpg"
        )
    }
}

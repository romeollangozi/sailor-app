//
//  HomeFooterSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 19.3.25.
//

import Foundation

struct HomeFooterSection: HomeSection {
    var id: String
    var key: SectionKey = .footer
    var title: String
    let description: String
    let pictogramUrl: String
}

extension HomeFooterSection {
    static func empty() -> HomeFooterSection {
        return HomeFooterSection(
            id: UUID().uuidString,
            title: "",
            description: "",
            pictogramUrl: ""
        )
    }
    
    static func sample()  -> HomeFooterSection {
        return HomeFooterSection(
            id: UUID().uuidString,
            title: "Bon Voyage!",
            description: "Enjoy your journey with Virgin Voyages",
            pictogramUrl: "https://example.com/footer-icon.png"
        )
    }
}



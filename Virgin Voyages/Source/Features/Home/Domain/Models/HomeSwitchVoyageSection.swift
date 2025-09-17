//
//  HomeSwitchVoyageSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Foundation

struct HomeSwitchVoyageSection: HomeSection {
    var id: String = UUID().uuidString
    var key: SectionKey = .switchVoyage
}

extension HomeSwitchVoyageSection {
    static func empty() -> HomeSwitchVoyageSection {
        return HomeSwitchVoyageSection(id: UUID().uuidString, key: .switchVoyage)
    }
}

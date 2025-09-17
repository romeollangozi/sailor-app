//
//  HomeSection.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

protocol HomeSection {
    var id: String { get }
    var key: SectionKey { get }
}

struct HomeSectionContainer: Identifiable {
    let homeSection: HomeSection
    
    init(_ homeSection: HomeSection) {
        self.homeSection = homeSection
    }
    
    var id: SectionKey {
        homeSection.key
    }
}

struct EmptySection: HomeSection {
    var id: String = UUID().uuidString
    var key: SectionKey = .header
    var title: String = ""
}

enum SectionKey: String, Codable {
    case header, checkIn, notifications, planner, planAndBook, merchandiseCarousel, addOnsPromo, myNextVirginVoyage, footer, addOns, musterDrill, plannerPreview, actions, addAFriend, switchVoyage
}

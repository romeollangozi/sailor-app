//
//  HomeHeader.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

struct HomeHeader: HomeSection {
    var id: String
    var key: SectionKey = .header
    var title: String
    let topBarTitle: String
    let topBarSubtitle: String
    let headerTitle: String
    let headerSubtitle: String
    let backgroundImageUrl: String
    let reservationNumber: String
    let cabinNumber: String
    let gangwayOpeningTime: String
    let gangwayClosingTime: String
    let shipTimeOffset: Int
}

extension HomeHeader {
    static func sample() -> HomeHeader {
        return HomeHeader(
            id: UUID().uuidString,
            key: .header,
            title: "Sample Header",
            topBarTitle: "Welcome Aboard",
            topBarSubtitle: "Your Adventure Begins",
            headerTitle: "Virgin Voyages",
            headerSubtitle: "Set Sail for Paradise",
            backgroundImageUrl: "https://example.com/header-bg.jpg",
            reservationNumber: "VV123456",
            cabinNumber: "A123",
            gangwayOpeningTime: "08:30 AM",
            gangwayClosingTime: "07:30 PM",
            shipTimeOffset: -300
        )
    }
}

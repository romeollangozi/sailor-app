//
//  HomeNotificationsSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.3.25.
//

import Foundation

struct HomeNotificationsSection: HomeSection, Equatable {
    var id: String
    var key: SectionKey = .notifications
    let unReadCount: Int
    let title: String
    let summary: String
    let createdAt: String
    var timeAgo: String {
        guard let createdAtDate = createdAt.iso8601 else { return "" }
        return createdAtDate.timeAgoDisplay()
    }
}

extension HomeNotificationsSection {
    static func empty() -> HomeNotificationsSection {
        return HomeNotificationsSection(
            id: UUID().uuidString,
            unReadCount: 0,
            title: "",
            summary: "",
            createdAt: ""
        )
    }
    
    static func sample() -> HomeNotificationsSection {
        return HomeNotificationsSection(
            id: UUID().uuidString,
            unReadCount: 3,
            title: "Someone’s booked you a Shore Thing",
            summary: "Don't forget your snorkeling adventure at 10:00 AM tomorrow.",
            createdAt: "2025-05-29T16:02:07.369Z"
        )
    }
}

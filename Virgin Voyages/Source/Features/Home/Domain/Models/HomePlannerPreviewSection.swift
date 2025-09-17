//
//  HomePlannerPreviewSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.3.25.
//

import Foundation

struct HomePlannerPreviewSection: HomeSection {
    var id: String = UUID().uuidString
    var key: SectionKey = .plannerPreview
    var title: String
    let description: String
    let thumbnailImageUrl: String
}

extension HomePlannerPreviewSection {
    static func empty() -> HomePlannerPreviewSection {
        return HomePlannerPreviewSection(
            id: UUID().uuidString,
            title: "",
            description: "",
            thumbnailImageUrl: ""
        )
    }
    
    static func sample()  -> HomePlannerPreviewSection {
        return HomePlannerPreviewSection(
            id: UUID().uuidString,
            title: "Manage your bookings and view the Line-up",
            description: "Start planning",
            thumbnailImageUrl: "https://example.com/line-up.jpg"
        )
    }
}

//
//  HomeMerchandise.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 16.3.25.
//

import Foundation

struct HomeMerchandise: HomeSection {

    var id: String
    var key: SectionKey = .merchandiseCarousel
    let items: [HomeMerchandiseItem]
    
    struct HomeMerchandiseItem {
        let title: String
        let imageUrl: String
        let color: String
        let code: String
    }
}

extension HomeMerchandise {
    static func empty() -> Self {
        return HomeMerchandise(
            id: UUID().uuidString,
            items: []
        )
    }

    static func sample() -> Self {
        return HomeMerchandise(
            id: UUID().uuidString,
            items: [
                HomeMerchandiseItem(
                    title: "First merchandise title",
                    imageUrl: "https://example.com/icon1.png",
                    color: "#CDB584",
                    code: "BSL 300"
                ),
                HomeMerchandiseItem(
                    title: "Sample merchandise title",
                    imageUrl: "https://example.com/icon2.png",
                    color: "#71D6E0",
                    code: "BSL 200"
                ),
                HomeMerchandiseItem(
                    title: "Sample merchandise title",
                    imageUrl: "https://example.com/icon3.png",
                    color: "#F7F7F7",
                    code: "BSL 100"
                )
            ]
        )
    }
}

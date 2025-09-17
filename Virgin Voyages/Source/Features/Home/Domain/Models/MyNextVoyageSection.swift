//
//  MyNextVoyageSection.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/18/25.
//

import Foundation

struct MyNextVoyageSection: HomeSection {
    
    var id: String
    var key: SectionKey = .myNextVirginVoyage
    var title: String
    let subTitle: String
    let dayRemaining: String
    let navigationUrl: String
    let imageURL: String
}

extension MyNextVoyageSection {
    static func sample() -> MyNextVoyageSection {
        return MyNextVoyageSection(id: UUID().uuidString,
                                   key: .myNextVirginVoyage,
                                   title: "Your Next Voyage",
                                   subTitle: "Claim your exclusive offer of $300 Discount + $600 Onboard Credit",
                                   dayRemaining: "10",
                                   navigationUrl: "https://example.com/next-voyage",
                                   imageURL: "https://example.com/image.jpg")
    }
}

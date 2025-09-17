//
//  ShoreThingPorts.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import Foundation

struct ShoreThingPorts {
    let items: [ShoreThingPort]
    let leadTime: LeadTime?
}

extension ShoreThingPorts {
    static func empty() -> ShoreThingPorts {
        return ShoreThingPorts(items: [], leadTime: .empty())
    }
    
    static func sample() -> ShoreThingPorts {
        let samplePorts = [
            ShoreThingPort(
                sequence: 1,
                name: "Miami",
                code: "MIA",
                slug: "port/miami",
                imageURL: "https://example.com/images/miami.jpg",
                dayType: .current,
                departureDateTime: Date(),
                arrivalDateTime: Date(),
                departureArrivalDateText: "THU MAY 29",
                departureArrivalTimeText: "Arrives at 08:00",
                guideText: "Your Miami Guide",
                actionURL: "https://example.com/port/miami"
            ),
            ShoreThingPort(
                sequence: 2,
                name: "Bimini",
                code: "BIM",
                slug: "port/bimini",
                imageURL: "https://example.com/images/bimini.jpg",
                dayType: .future,
                departureDateTime: Date(),
                arrivalDateTime: Date(),
                departureArrivalDateText: "THU MAY 29",
                departureArrivalTimeText: "Arrives at 08:00, Departs at 17:00",
                guideText: "Your Bimini Guide",
                actionURL: "https://example.com/port/bimini"
            )
        ]
        
        return ShoreThingPorts(
            items: samplePorts,
            leadTime: .sample()
        )
    }
}



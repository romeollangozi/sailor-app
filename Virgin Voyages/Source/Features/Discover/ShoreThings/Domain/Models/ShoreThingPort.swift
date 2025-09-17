//
//  ShoreThingPort.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import Foundation

struct ShoreThingPort: Identifiable, Hashable {
    var id = UUID()
    let sequence: Int
    let name: String
    let code: String
    let slug: String
    let imageURL: String
    let dayType: ShoreThingDayType
    let departureDateTime: Date?
    let arrivalDateTime: Date?
    let departureArrivalDateText: String
    let departureArrivalTimeText: String
    let guideText: String
    let actionURL: String
}

enum ShoreThingDayType: String {
    case passed = "Passed"
    case current = "Current"
    case future = "Future"
}

extension ShoreThingPort {
    static func empty() -> ShoreThingPort {
        return ShoreThingPort(
            sequence: 0,
            name: "",
            code: "",
            slug: "",
            imageURL: "",
            dayType: .passed,
            departureDateTime: Date(),
            arrivalDateTime: Date(),
            departureArrivalDateText: "",
            departureArrivalTimeText: "",
            guideText: "",
            actionURL: ""
        )
    }
}

extension ShoreThingPort {
    func toDomain() -> PortDestination {
        .init(
            portName: name,
            portCode: code,
            departureTime: departureDateTime?.toISO8601() ?? "",
            tabLabel: code,
            sequence: sequence,
            cardSubHeader: guideText,
            arrivalDateTime: arrivalDateTime?.toISO8601() ?? "",
            excursionsBtnActionURL: "",
            journeyImageURL: "",
            actionURL: ""
        )
    }
}

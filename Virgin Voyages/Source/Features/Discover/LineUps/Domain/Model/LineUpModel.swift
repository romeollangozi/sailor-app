//
//  LineUpModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//

import Foundation

struct LineUpModel {
    let itineraryDays: [ItineraryDay]
	var itineraryDates: [Date] { itineraryDays.getDates() }
    var selectedDate: Date
    let events: [LineUpEvents]
    let leadTime: LeadTime
}

extension LineUpModel {
    static func empty() -> LineUpModel {
        LineUpModel(itineraryDays: [], selectedDate: Date(), events: [], leadTime: LeadTime.empty())
    }

    static func sample() -> LineUpModel {
        let itineraryDays = [
            ItineraryDay(
                itineraryDay: 1,
                isSeaDay: false,
                portCode: "MIA",
                day: "Saturday",
                dayOfWeek: "S",
                dayOfMonth: "28",
                date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!,
                portName: "Miami"
            ),
            ItineraryDay(
                itineraryDay: 2,
                isSeaDay: true,
                portCode: "",
                day: "Sunday",
                dayOfWeek: "S",
                dayOfMonth: "29",
                date: ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!,
                portName: ""
            )
        ]

        return LineUpModel(
			itineraryDays: itineraryDays,
			selectedDate: itineraryDays[0].date,
            events: LineUpEvents.sample(),
            leadTime: LeadTime.sample()
		)
    }
}

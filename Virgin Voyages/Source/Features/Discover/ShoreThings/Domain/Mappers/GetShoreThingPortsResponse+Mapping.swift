//
//  GetShoreThingPortsResponse.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import Foundation

extension GetShoreThingPortsResponse {
    func toDomain() -> ShoreThingPorts {
        .init(
            items: self.items?.map({$0.toDomain()}) ?? [],
            leadTime: self.leadTime != nil ? self.leadTime?.toDomain() : nil
        )
    }
}

extension GetShoreThingPortsResponse.ShoreThingPort {
    func toDomain() -> ShoreThingPort {
        .init(
            sequence: self.sequence.value,
            name: self.name.value,
            code: self.code.value,
            slug: self.slug.value,
            imageURL: self.imageUrl.value,
            dayType: .init(rawValue: self.dayType.value) ?? .passed,
			departureDateTime: self.departureDateTime != nil ? Date.fromISOString(string: self.departureDateTime ) : nil,
            arrivalDateTime: self.arrivalDateTime != nil ? Date.fromISOString(string: self.arrivalDateTime ) : nil,
            departureArrivalDateText: self.departureArrivalDateText.value,
            departureArrivalTimeText: self.departureArrivalTimeText.value,
            guideText: self.guideText.value,
			actionURL: self.guideUrl.value
        )
    }
}

extension GetShoreThingPortsResponse.LeadTime {
    func toDomain() -> LeadTime {
        return LeadTime(
            title: self.title.value,
            description: self.description.value,
            imageUrl: self.imageUrl.value,
            date: self.date?.iso8601.value ?? Date(),
            isCountdownStarted: self.isCountdownStarted.value,
            timeLeftToBookingStartInSeconds: self.timeLeftToBookingStartInSeconds.value
        )
    }
}


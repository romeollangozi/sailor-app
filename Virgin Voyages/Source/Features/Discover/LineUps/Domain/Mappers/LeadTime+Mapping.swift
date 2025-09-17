//
//  GetLeadTime+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 10.4.25.
//

import Foundation

extension GetLineUpRequestResponse.LeadTime {
    func toDomain() -> LeadTime {
        return LeadTime(
            title: title.value,
            description: description.value,
            imageUrl: imageUrl.value,
            date: date?.iso8601 ?? Date(),
            isCountdownStarted: isCountdownStarted ?? false,
            timeLeftToBookingStartInSeconds: timeLeftToBookingStartInSeconds.value
        )
    }
}

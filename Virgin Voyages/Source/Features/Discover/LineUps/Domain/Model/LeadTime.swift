//
//  LeadTime.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 9.4.25.
//

import Foundation

struct LeadTime: Equatable, Hashable {
    let title: String
    let description: String
    let imageUrl: String
    let date: Date
    let isCountdownStarted: Bool
    let timeLeftToBookingStartInSeconds: Int

    static func sample() -> LeadTime {
        return LeadTime(
            title: "The Event Line-Up opens at June 12, 2025",
            description: "Pop back then when onboard activities will be open for booking.",
            imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:6503487e-c3f5-417b-bf8d-864bdad4e1c9/ILL-ENT-UK-Summer-Series-Entertainment-Heartbeat-600x400%20(2).jpg",
            date: ISO8601DateFormatter().date(from: "2025-06-12T00:00") ?? Date(),
            isCountdownStarted: false,
            timeLeftToBookingStartInSeconds: 5494898
        )
    }

    static func empty() -> LeadTime {
        return LeadTime(
            title: "",
            description: "",
            imageUrl: "",
            date: Date(),
            isCountdownStarted: false,
            timeLeftToBookingStartInSeconds: 0
        )
    }
}

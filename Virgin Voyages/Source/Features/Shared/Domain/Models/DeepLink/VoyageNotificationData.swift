//
//  VoyageNotificationData.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/13/25.
//

import Foundation

struct VoyageNotificationData: Codable {
    let activityCode: String?
    let currentDay: Int?
    let portDepartureTime: String?
    let bookingLinkId: String?
    let isBookingProcess: Bool?
    let appointmentId: String?
    let externalBookingId: String?
    let currentDate: [Int]?
    let categoryCode: String?
    let portCode: String?
    let portArrivalTime: String?
}

//
//  TravelPartyNotificationData.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/8/25.
//

import Foundation

struct TravelPartyNotificationData: Codable {
    let activityCode: String?
    let currentDay: Double?
    let bookingLinkId: String?
    let isBookingProcess: Bool?
    let appointmentId: String?
    let currentDate: [Double]?
    let categoryCode: String?
}

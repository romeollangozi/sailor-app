//
//  ARSNotificationData.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/14/25.
//

import Foundation

struct ARSNotificationData: Codable {
    let eventSenderUserType : String?
    let eventSenderUserId : String?
    let bookingLinkId : String?
    let appointmentId : String?
    let currentDate: [Double]?
}

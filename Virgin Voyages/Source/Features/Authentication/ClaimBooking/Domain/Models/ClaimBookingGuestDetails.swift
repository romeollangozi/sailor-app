//
//  ClaimBookingGuestDetails.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/17/24.
//

import Foundation

struct ClaimBookingGuestDetails: Hashable {
    let name: String
    let lastName: String
    let reservationNumber: String
    let email: String?
    let reservationGuestID: String
    let genderCode: String
    var birthDate: Date?
    
    init(name: String,
         lastName: String,
         reservationNumber: String,
         email: String? = nil,
         birthDate: Date?,
         reservationGuestID: String,
         genderCode: String) {
        self.name = name
        self.lastName = lastName
        self.reservationNumber = reservationNumber
        self.email = email
        self.birthDate = birthDate
        self.reservationGuestID = reservationGuestID
        self.genderCode = genderCode
    }
    
    init(email: String? = nil,
         lastName: String,
         birthDate: Date?,
         reservationNumber: String,
         reservationGuestID: String) {
        
        self.email = email
        self.lastName = lastName
        self.birthDate = birthDate
        self.reservationNumber = reservationNumber
        self.reservationGuestID = reservationGuestID
        self.name = ""
        self.genderCode = ""
    }
    
    static func empty() -> ClaimBookingGuestDetails {
        return ClaimBookingGuestDetails(name: "Silver", lastName: "Surfer", reservationNumber: "", email: "silver@surfer.com", birthDate: Date(), reservationGuestID: "", genderCode: "")
    }
}

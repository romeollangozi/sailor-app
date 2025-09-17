//
//  LoginGuestDetails.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 10.8.25.
//

import Foundation

struct LoginGuestDetails: Hashable {
    let name: String
    let lastName: String
    let reservationNumber: String
    let reservationGuestID: String
    let profilePhotoUrl: String
    var birthDate: Date?
    
    init(name: String,
         lastName: String,
         reservationNumber: String,
         reservationGuestID: String,
         profilePhotoUrl: String,
         birthDate: Date?
    ) {
        self.name = name
        self.lastName = lastName
        self.reservationNumber = reservationNumber
        self.reservationGuestID = reservationGuestID
        self.profilePhotoUrl = profilePhotoUrl
        self.birthDate = birthDate
    }
    
    static func empty() -> LoginGuestDetails {
        return LoginGuestDetails(name: "", lastName: "", reservationNumber: "", reservationGuestID: "", profilePhotoUrl: "", birthDate: Date())
    }
    
    static func sample() -> LoginGuestDetails {
        return LoginGuestDetails(name: "Tom", lastName: "Test", reservationNumber: "", reservationGuestID: "", profilePhotoUrl: "", birthDate: Date())
    }
}

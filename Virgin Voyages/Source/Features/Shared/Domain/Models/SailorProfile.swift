//
//  SailorProfile.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import Foundation

class SailorProfile {
    let email: String
    let firstName: String
    let lastName: String
    let dateOfBirth: Date?
    let photoURL: String

    init(email: String,
         firstName: String,
         lastName: String,
         dateOfBirth: Date?,
         photoURL: String, geneder: String? = nil ,
         nationality: String? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.photoURL = photoURL
    }
}

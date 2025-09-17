//
//  SocialUser.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.9.24.
//

import Foundation

struct SocialUser {
    let id: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let profileImageUrl: String?
    var socialNetworkAPIAccessToken: String?
    var dateOfBirth: Date?
    
    var dateOfBirthComponents: DateComponents {
        guard let dateOfBirth = dateOfBirth else {
            return DateComponents(calendar: Calendar.current)
        }
        
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day], from: dateOfBirth)
    }
}

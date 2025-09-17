//
//  LoginType.swift
//  Virgin Voyages
//
//  Created by TX on 22.7.25.
//

import Foundation

enum LoginType {
    case email(email: String, password: String)
    case cabin(cabinNumber: String, lastName: String, birthday: Date, reservationGuestId: String? = nil)
    case reservation(lastName: String, reservationNumber: String, birthDate: Date, sailDate: Date, reservationGuestId: String? = nil, recaptchaToken: String? = nil)
    case social(socialMediaId: String, type: Endpoint.GetSocialAccount.SocialMediaType)
}

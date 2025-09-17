//
//  reCaptchaActions.swift
//  Virgin Voyages
//
//  Created by TX on 14.7.25.
//

import Foundation

enum ReCaptchaActions {
    case loginWithReseservationNumber
    case claimABooking
    case requestNewPassword

    var key: String {
        switch self {
        case .loginWithReseservationNumber:
            return "login_by_reservation_number"
        case .claimABooking:
            return "claim_a_booking"
        case .requestNewPassword:
            return "password_reset"
        }
    }
}

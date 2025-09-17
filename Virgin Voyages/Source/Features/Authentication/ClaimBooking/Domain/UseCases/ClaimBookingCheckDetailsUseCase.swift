//
//  ClaimBookingCheckDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.12.24.
//

import Foundation
import VVUIKit

protocol ClaimBookingCheckDetailsUseCaseProtocol {
    func execute() async -> ClaimBookingCheckDetails
    var sailorProfileDetails: ClaimBookingGuestDetails { get }
}


class ClaimBookingCheckDetailsUseCase: ClaimBookingCheckDetailsUseCaseProtocol {
    var sailorProfileDetails: ClaimBookingGuestDetails

    init(sailorProfileDetails: ClaimBookingGuestDetails) {
        self.sailorProfileDetails = sailorProfileDetails
    }
    
    func execute() -> ClaimBookingCheckDetails {

        let firstName = sailorProfileDetails.name
        let lastName = sailorProfileDetails.lastName
        let email = sailorProfileDetails.email
        let gender = sailorProfileDetails.genderCode
        let birthDate = sailorProfileDetails.birthDate?.toMonthDDYYY()
    
		return ClaimBookingCheckDetails(name: "First Name: \(firstName.masked(as: .partialPrefix))",
                                        lastName: "Last Name: \(lastName.masked(as: .partialPrefix))",
										email: email != nil ? "Email: \(email.value)" : nil,
                                        gender: "Sex: \(gender)",
										birthDate: "Date of birth: \(birthDate.value.masked(as: .hideYear))", dateOfBirth: sailorProfileDetails.birthDate)
    }
    
}

struct ClaimBookingCheckDetails {
    
    let name: String
    let lastName: String
    let email: String?
    let gender: String
    let birthDate: String
    let dateOfBirth: Date?
    
    let title = "Check your booking details"
    let description = "Check your details carefully, if any of your details below are incorrect, please contact sailor services."
    let bookingDetailTitle = "Booking details:"
    let claimBookingButton = "Claim your booking"
    let cancelButton = "Cancel"
    
    init(name: String, lastName: String, email: String? = nil, gender: String, birthDate: String, dateOfBirth: Date?) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.gender = gender
        self.birthDate = birthDate
        self.dateOfBirth = dateOfBirth
    }
    
    static func empty() -> ClaimBookingCheckDetails {
        ClaimBookingCheckDetails(name: "", lastName: "", email: "", gender: "", birthDate: "", dateOfBirth: nil)
    }
    
    var items: [String] {
		if let email = email {
			return [name, lastName, email, birthDate]
		} else {
			return [name, lastName, birthDate]
		}
    }
}

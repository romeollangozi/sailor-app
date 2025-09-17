//
//  ClaimBookingResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by TX on 14.7.25.
//

import Foundation

extension ClaimBookingResponse {
    func toDomain() -> ClaimBooking {
        let mappedStatus: ClaimBooking.Status
        switch status {
        case .success: mappedStatus = .success
        case .bookingNotFound: mappedStatus = .bookingNotFound
        case .emailConflict: mappedStatus = .emailConflict
        case .guestConflict: mappedStatus = .guestConflict
        default: mappedStatus = .unknown
        }

        let guestDetails = response?.guestDetails?.map { $0.toModel() } ?? []

        return ClaimBooking(
            status: mappedStatus,
            guestDetails: guestDetails
        )
    }
}

extension ClaimBookingResponse.GuestDetails {
    func toModel() -> ClaimBookingGuestDetails {
        return ClaimBookingGuestDetails(
            name: name.value,
            lastName: lastName.value,
            reservationNumber: reservationNumber.value,
            email: email.value,
            birthDate: birthDate?.fromYYYYMMDD() ?? nil,
            reservationGuestID: reservationGuestId.value,
            genderCode: genderCode.value
        )
    }
}

//
//  CancelAppointmentInputModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.2.25.
//

import Foundation

struct CancelAppointmentInputModel {
    let appointmentLinkId: String
    let categoryCode: String
    let numberOfGuests: Int
    let isRefund: Bool
    let personDetails: [PersonDetail]
    struct PersonDetail: Codable {
        let personId: String
        let guestId: String
        let reservationNumber: String
        let status: String
    }

    static func map(from sailors: [SailorModel]) -> [PersonDetail] {
        return sailors.map { sailor in
            PersonDetail(
                personId: sailor.id,
                guestId: sailor.guestId,
                reservationNumber: sailor.reservationNumber,
                status: "CANCELLED"
            )
        }
    }
}

extension CancelAppointmentInputModel {
    static func mock() -> CancelAppointmentInputModel {
        let personDetail = PersonDetail(
            personId: "person123",
            guestId: "guest123",
            reservationNumber: "resNum123",
            status: "CANCELLED"
        )

        return CancelAppointmentInputModel(
            appointmentLinkId: "12345",
            categoryCode: "ACTIVITY",
            numberOfGuests: 1,
            isRefund: true,
            personDetails: [personDetail]
        )
    }

    static func empty() -> CancelAppointmentInputModel {
        return CancelAppointmentInputModel(
            appointmentLinkId: "",
            categoryCode: "",
            numberOfGuests: 1,
            isRefund: true,
            personDetails: []
        )
    }
}

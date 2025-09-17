//
//  SailorReservations.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

import Foundation

struct SailorReservations {
    let profilePhotoURL: String
    let pageDetails: PageDetails
    let guestBookings: [GuestBooking]
    
    struct PageDetails {
        let buttons: Buttons
        let imageUrl: String
        let description: String
        let title: String
        let labels: Labels
    }
    
    struct Buttons {
        let bookVoyage: String
        let connectBooking: String
    }
    
    struct Labels {
        let date: String
        let archived: String
    }
    
    struct GuestBooking {
        let guestName: String
        let voyageDate: String
        let voyageName: String
        let ports: [String]
        let reservationNumber: String
        let guestId: String
        let reservationGuestId: String
        let reservationId: String
        let portNames: [String]
        let voyageNumber: String
        let status: String
        let isPastBooking: Bool
        let isActiveBooking: Bool
        let imageUrl: String
        let embarkDate: String
        let shipCode: String
        let shipName: String
        let isArchivedBooking: Bool
        let portsMapping: [PortMapping]
    }
    
    struct PortMapping {
        let name: String
        let externalId: String
    }
}

extension SailorReservations {
    static func map(from response: GetSailorReservationsResponse) -> SailorReservations {
        return SailorReservations(
            profilePhotoURL: response.profilePhotoURL.value,
            pageDetails: SailorReservations.PageDetails(
                buttons: SailorReservations.Buttons(
                    bookVoyage: response.pageDetails?.buttons?.bookVoyage.value ?? "",
                    connectBooking: response.pageDetails?.buttons?.connectBooking.value ?? ""
                ),
                imageUrl: response.pageDetails?.imageUrl.value ?? "",
                description: response.pageDetails?.description.value ?? "",
                title: response.pageDetails?.title.value ?? "",
                labels: SailorReservations.Labels(
                    date: response.pageDetails?.labels?.date.value ?? "",
                    archived: response.pageDetails?.labels?.archived.value ?? ""
                )
            ),
            guestBookings: response.guestBookings?.map { booking in
                GuestBooking(
                    guestName: booking.guestName.value,
                    voyageDate: booking.voyageDate.value,
                    voyageName: booking.voyageName.value,
                    ports: booking.ports?.compactMap { $0 } ?? [],
                    reservationNumber: booking.reservationNumber.value,
                    guestId: booking.guestId.value,
                    reservationGuestId: booking.reservationGuestId.value,
                    reservationId: booking.reservationId.value,
                    portNames: booking.portNames?.compactMap { $0 } ?? [],
                    voyageNumber: booking.voyageNumber.value,
                    status: booking.status.value,
                    isPastBooking: booking.isPastBooking.value,
                    isActiveBooking: booking.isActiveBooking.value,
                    imageUrl: booking.imageUrl.value,
                    embarkDate: booking.embarkDate.value,
                    shipCode: booking.shipCode.value,
                    shipName: booking.shipName.value,
                    isArchivedBooking: booking.isArchivedBooking.value,
                    portsMapping: booking.portsMapping?.map {
                        PortMapping(
                            name: $0.name.value,
                            externalId: $0.externalId.value
                        )
                    } ?? []
                )
            } ?? []
        )
    }
    
    static func empty() -> SailorReservations {
        return SailorReservations(
            profilePhotoURL: "",
            pageDetails: PageDetails(
                buttons: Buttons(
                    bookVoyage: "",
                    connectBooking: ""
                ),
                imageUrl: "",
                description: "",
                title: "",
                labels: Labels(
                    date: "",
                    archived: ""
                )
            ),
            guestBookings: [
                GuestBooking(
                    guestName: "",
                    voyageDate: "",
                    voyageName: "",
                    ports: [],
                    reservationNumber: "",
                    guestId: "",
                    reservationGuestId: "",
                    reservationId: "",
                    portNames: [],
                    voyageNumber: "",
                    status: "",
                    isPastBooking: false,
                    isActiveBooking: false,
                    imageUrl: "",
                    embarkDate: "",
                    shipCode: "",
                    shipName: "",
                    isArchivedBooking: false,
                    portsMapping: [
                        PortMapping(
                            name: "",
                            externalId: ""
                        )
                    ]
                )
            ]
        )
    }
}

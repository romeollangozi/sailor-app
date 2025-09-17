//
//  VoyageReservationsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 1.6.25.
//

extension VoyageReservationsResponse {
    func toDomain() -> VoyageReservations {
        return VoyageReservations(
            profilePhotoURL: self.profilePhotoURL.value,
            pageDetails: VoyageReservations.PageDetails(
                buttons: VoyageReservations.PageDetails.Buttons(
                    bookVoyage: self.pageDetails?.buttons?.bookVoyage ?? "",
                    connectBooking: self.pageDetails?.buttons?.connectBooking ?? ""
                ),
                imageURL: self.pageDetails?.imageUrl ?? "",
                description: self.pageDetails?.description ?? "",
                title: self.pageDetails?.title ?? "",
                labels: VoyageReservations.PageDetails.Labels(
                    date: self.pageDetails?.labels?.date ?? "",
                    archived: self.pageDetails?.labels?.archived ?? ""
                )
            ),
            guestBookings: self.guestBookings?.map { booking in
                return VoyageReservations.GuestBooking(
                    guestName: booking.guestName.value,
                    voyageDate: booking.voyageDate.value,
                    voyageName: booking.voyageName.value,
                    ports: (booking.ports ?? []).compactMap { $0 ?? "" },
                    reservationNumber: booking.reservationNumber ?? "",
                    guestId: booking.guestId.value,
                    reservationGuestId: booking.reservationGuestId.value,
                    reservationId: booking.reservationId.value,
                    portNames: booking.portNames ?? [],
                    voyageNumber: booking.voyageNumber.value,
                    status: booking.status.value,
                    isPastBooking: booking.isPastBooking ?? false,
                    isActiveBooking: booking.isActiveBooking ?? false,
                    imageUrl: booking.imageUrl.value,
                    embarkDate: booking.embarkDate.value,
                    shipCode: booking.shipCode.value,
                    shipName: booking.shipName.value,
                    isArchivedBooking: booking.isArchivedBooking ?? false,
                    portsMapping: (booking.portsMapping ?? []).map { port in
                        return VoyageReservations.GuestBooking.PortMapping(
                            name: port.name.value,
                            externalId: port.externalId.value
                        )
                    },
                    bookedDate: booking.bookedDate.value
                )
            } ?? []
        )
    }
}

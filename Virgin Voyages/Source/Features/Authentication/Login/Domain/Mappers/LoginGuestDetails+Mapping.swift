//
//  LoginGuestDetails+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 12.8.25.
//

extension Endpoint.GetReservationNumber.Response.GuestDetail {
    func toModel() -> LoginGuestDetails {
        return LoginGuestDetails(
            name: name.value,
            lastName: lastName.value,
            reservationNumber: reservationNumber.value,
            reservationGuestID: reservationGuestId.value,
            profilePhotoUrl: profilePhotoUrl.value,
            birthDate: birthDate?.fromYYYYMMDD()
        )
    }
}

extension Endpoint.GetCabinAccount.Response.GuestDetail {
    func toModel() -> LoginGuestDetails {
        return LoginGuestDetails(
            name: name.value,
            lastName: lastName.value,
            reservationNumber: reservationNumber.value,
            reservationGuestID: reservationGuestId.value,
            profilePhotoUrl: profilePhotoUrl.value,
            birthDate: birthDate?.fromYYYYMMDD()
        )
    }
}



//
//  GetSailorsProfileResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Foundation

extension GetSailorsProfileResponse {
    func toDomain() -> SailorProfileV2 {
        return SailorProfileV2(
            userId: userId.value,
            email: email.value,
            firstName: firstName.value,
            lastName: lastName.value,
            preferredName: preferredName.value,
            genderCode: genderCode.value,
            photoUrl: photoUrl.value,
            birthDate: birthDate.value,
            citizenshipCountryCode: citizenshipCountryCode.value,
            phoneCountryCode: phoneCountryCode.value,
            phoneNumber: phoneNumber.value,
            type: SailorType(rawValue: type ?? "") ?? .standard,
            typeCode: typeCode.value,
			cabinNumber: reservation?.cabinNumber.value,
			errorState: SailorProfileV2ErrorState(rawValue: errorState ?? ""),
            reservation: reservation?.toDomain(),
            upcomingReservation: upcomingReservation?.toDomain(),
			externalRefId: self.externalRefId.value
        )
    }
}

private extension GetSailorsProfileResponse.Reservation {
    func toDomain() -> SailorProfileV2.Reservation {
        return SailorProfileV2.Reservation(
            status: ReservationStatus(rawValue: status ?? "") ?? .noShow,
            shipCode: shipCode ?? "",
            shipName: shipName ?? "",
            isPassed: isPassed ?? false,
            voyageId: voyageId ?? "",
            voyageNumber: voyageNumber ?? "",
            embarkDate: embarkDate ?? "",
            debarkDate: debarkDate ?? "",
            embarkDateTime: embarkDateTime ?? "",
            debarkDateTime: debarkDateTime.value,
            reservationId: reservationId ?? "",
            reservationNumber: reservationNumber ?? "",
            guestId: guestId ?? "",
            reservationGuestId: reservationGuestId ?? "",
            deckPlanUrl: deckPlanUrl ?? "",
            itineraries: itineraries?.compactMap { $0.toDomain() } ?? []
        )
    }
}

private extension GetSailorsProfileResponse.Itinerary {
    func toDomain() -> SailorProfileV2.Itinerary? {
        return SailorProfileV2.Itinerary(
            dayType: dayType ?? "",
            dayNumber: dayNumber ?? 0,
			date: Date.fromISOString(string: date),
            dayOfWeekCode: dayOfWeekCode ?? "",
            dayOfWeek: dayOfWeek ?? "",
            dayOfMonth: dayOfMonth ?? "",
            isPortDay: isPortDay ?? false,
            portCode: portCode ?? "",
            portName: portName ?? ""
        )
    }
}




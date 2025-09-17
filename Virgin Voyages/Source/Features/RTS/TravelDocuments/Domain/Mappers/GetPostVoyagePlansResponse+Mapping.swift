//
//  GetPostVoyagePlansResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

extension GetPostVoyagePlansResponse {
    func toDomain() -> PostVoyagePlans {
        return PostVoyagePlans(
            isStayingIn: isStayingIn ?? true,
            stayTypeCode: StayTypeCode(rawValue: stayTypeCode.value) ?? .other,
            addressInfo: PostVoyagePlans.AddressInfo(
                line1: addressInfo?.line1.value ?? "",
                line2: addressInfo?.line2.value ?? "",
                city: addressInfo?.city.value ?? "",
                countryCode: addressInfo?.countryCode.value ?? "",
                zipCode: addressInfo?.zipCode.value ?? "",
                stateCode: addressInfo?.stateCode.value ?? "",
                hotelName: addressInfo?.hotelName.value ?? "",
                addressTypeCode: addressInfo?.addressTypeCode.value ?? ""
            ),
            transportationTypeCode: TransportationTypeCode(rawValue: transportationTypeCode.value) ?? .land,
            flightDetails: PostVoyagePlans.FlightDetails(
                airlineCode: flightDetails?.airlineCode.value ?? "",
                departureAirportCode: flightDetails?.departureAirportCode.value ?? "",
                number: flightDetails?.number.value ?? ""
            )
        )
    }
}

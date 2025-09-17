//
//  SavePostVoyagePlans+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

extension PostVoyagePlansInput {
    func toNetworkDTO() -> SavePostVoyagePlansBody {
        let address = self.addressInfo.map {
            SavePostVoyagePlansBody.AddressInfo(
                line1: $0.line1,
                line2: $0.line2,
                city: $0.city,
                countryCode: $0.countryCode,
                zipCode: $0.zipCode,
                stateCode: $0.stateCode,
                hotelName: $0.hotelName,
                addressTypeCode: $0.addressTypeCode
            )
        }

        let flight = self.flightDetails.map {
            SavePostVoyagePlansBody.FlightDetails(
                airlineCode: $0.airlineCode,
                departureAirportCode: $0.departureAirportCode,
                number: $0.number
            )
        }

        return SavePostVoyagePlansBody(
            isStayingIn: self.isStayingIn,
            stayTypeCode: self.stayTypeCode,
            addressInfo: address,
            transportationTypeCode: self.transportationTypeCode,
            flightDetails: flight
        )
    }
}

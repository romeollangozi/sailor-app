//
//  PostVoyagePlans+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 26.3.25.
//

import Foundation

extension PostVoyagePlans {
    func toInputModel() -> PostVoyagePlansInput {
        return PostVoyagePlansInput(
            isStayingIn: self.isStayingIn,
            stayTypeCode: self.stayTypeCode.rawValue,
            addressInfo: PostVoyagePlansInput.AddressInfo(
                line1: self.addressInfo.line1,
                line2: self.addressInfo.line2,
                city: self.addressInfo.city,
                countryCode: self.addressInfo.countryCode,
                zipCode: self.addressInfo.zipCode,
                stateCode: self.addressInfo.stateCode,
                hotelName: self.addressInfo.hotelName,
                addressTypeCode: self.addressInfo.addressTypeCode
            ),
            transportationTypeCode: self.transportationTypeCode.rawValue,
            flightDetails: PostVoyagePlansInput.FlightDetails(
                airlineCode: self.flightDetails.airlineCode,
                departureAirportCode: self.flightDetails.departureAirportCode,
                number: self.flightDetails.number
            )
        )
    }
}

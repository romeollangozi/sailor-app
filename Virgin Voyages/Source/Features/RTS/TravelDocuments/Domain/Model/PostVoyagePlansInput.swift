//
//  PostVoyagePlansInput.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 26.3.25.
//

import Foundation

struct PostVoyagePlansInput: Equatable, Hashable {
    var isStayingIn: Bool
    var stayTypeCode: String
    var addressInfo: AddressInfo?
    var transportationTypeCode: String
    var flightDetails: FlightDetails?

    struct AddressInfo: Equatable, Hashable {
        var line1: String?
        var line2: String?
        var city: String?
        var countryCode: String?
        var zipCode: String?
        var stateCode: String?
        var hotelName: String?
        var addressTypeCode: String?
    }

    struct FlightDetails: Equatable, Hashable {
        var airlineCode: String?
        var departureAirportCode: String?
        var number: String?
    }

    static func empty() -> PostVoyagePlansInput {
        return PostVoyagePlansInput(
            isStayingIn: false,
            stayTypeCode: "",
            addressInfo: AddressInfo(
                line1: "",
                line2: "",
                city: "",
                countryCode: "",
                zipCode: "",
                stateCode: "",
                hotelName: "",
                addressTypeCode: ""
            ),
            transportationTypeCode: "",
            flightDetails: FlightDetails(
                airlineCode: "",
                departureAirportCode: "",
                number: ""
            )
        )
    }
}

extension PostVoyagePlansInput {
    static func sample() -> PostVoyagePlansInput {
        return PostVoyagePlansInput(
            isStayingIn: true,
            stayTypeCode: "HOTEL",
            addressInfo: AddressInfo(
                line1: "123 Ocean Drive",
                line2: "Suite 456",
                city: "Miami",
                countryCode: "US",
                zipCode: "33139",
                stateCode: "FL",
                hotelName: "Sailor's Inn"
            ),
            transportationTypeCode: "FLIGHT",
            flightDetails: FlightDetails(
                airlineCode: "AA",
                departureAirportCode: "MIA",
                number: "AA123"
            )
        )
    }
}

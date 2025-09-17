//
//  PostVoyagePlans.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

enum StayTypeCode: String, Codable, CaseIterable {
    case hotel = "HOTEL"
    case home = "HOME"
    case other = "OTHER"
    
    var label: String {
        switch self {
        case .hotel: return "Hotel"
        case .home: return "Private residence"
        case .other: return "Other"
        }
    }
}

enum TransportationTypeCode: String, Codable, CaseIterable {
    case air = "AIR"
    case land = "LAND"
    case water = "WATER"
    
    var label: String {
        switch self {
        case .air: return "I will be departing by Air"
        case .land: return "I will be departing by Land"
        case .water: return "I will be departing by Sea"
        }
    }
}

struct PostVoyagePlans: Equatable, Hashable {
    var isStayingIn: Bool
    var stayTypeCode: StayTypeCode
    var addressInfo: AddressInfo
    var transportationTypeCode: TransportationTypeCode
    var flightDetails: FlightDetails

    struct AddressInfo: Equatable, Hashable {
        var line1: String
        var line2: String
        var city: String
        var countryCode: String
        var zipCode: String
        var stateCode: String
        var hotelName: String
        let addressTypeCode: String
    }

    struct FlightDetails: Equatable, Hashable {
        var airlineCode: String
        var departureAirportCode: String
        var number: String
    }

    static func empty() -> PostVoyagePlans {
        return PostVoyagePlans(
            isStayingIn: false,
            stayTypeCode: .hotel,
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
            transportationTypeCode: .air,
            flightDetails: FlightDetails(
                airlineCode: "",
                departureAirportCode: "",
                number: ""
            )
        )
    }
}

extension PostVoyagePlans {
    static func sample() -> PostVoyagePlans {
        return PostVoyagePlans(
            isStayingIn: true,
            stayTypeCode: .hotel,
            addressInfo: AddressInfo(
                line1: "34567",
                line2: "Test",
                city: "Test",
                countryCode: "US",
                zipCode: "34567",
                stateCode: "MS",
                hotelName: "",
                addressTypeCode: ""
            ),
            transportationTypeCode: .air,
            flightDetails: FlightDetails(
                airlineCode: "AA",
                departureAirportCode: "MIA",
                number: "2757"
            )
        )
    }
}

//
//  GetPostVoyagePlansRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

struct GetPostVoyagePlansRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String

    var path: String {
        return NetworkServiceEndpoint.getPostVoyagePlans
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "reservationGuestId", value: reservationGuestId)
        ]
    }
}

struct GetPostVoyagePlansResponse: Decodable {
    let isStayingIn: Bool?
    let stayTypeCode: String?
    let addressInfo: AddressInfo?
    let transportationTypeCode: String?
    let flightDetails: FlightDetails?

    struct AddressInfo: Decodable {
        let line1: String?
        let line2: String?
        let city: String?
        let countryCode: String?
        let zipCode: String?
        let stateCode: String?
        let hotelName: String?
        let addressTypeCode: String?
    }

    struct FlightDetails: Decodable {
        let airlineCode: String?
        let departureAirportCode: String?
        let number: String?
    }
}

extension NetworkServiceProtocol {
    func getPostVoyagePlans(reservationGuestId: String) async throws -> GetPostVoyagePlansResponse? {
        let request = GetPostVoyagePlansRequest(reservationGuestId: reservationGuestId)
        return try await self.requestV2(request, responseModel: GetPostVoyagePlansResponse.self)
    }
}

//
//  SavePostVoyagePlansRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

struct SavePostVoyagePlansRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String
    var body: SavePostVoyagePlansBody?

    var path: String {
        return NetworkServiceEndpoint.getPostVoyagePlans
    }

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "reservationGuestId", value: reservationGuestId)
        ]
    }

    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }
}

struct SavePostVoyagePlansBody: Encodable {
    var isStayingIn: Bool?
    var stayTypeCode: String?
    var addressInfo: AddressInfo?
    var transportationTypeCode: String?
    var flightDetails: FlightDetails?

    struct AddressInfo: Encodable {
        var line1: String?
        var line2: String?
        var city: String?
        var countryCode: String?
        var zipCode: String?
        var stateCode: String?
        var hotelName: String?
        var addressTypeCode: String?
    }

    struct FlightDetails: Encodable {
        var airlineCode: String?
        var departureAirportCode: String?
        var number: String?
    }
}

extension NetworkServiceProtocol {
    func savePostVoyagePlans(reservationGuestId: String, body: SavePostVoyagePlansBody?) async throws -> EmptyResponse{
        let request = SavePostVoyagePlansRequest(reservationGuestId: reservationGuestId, body: body)
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}

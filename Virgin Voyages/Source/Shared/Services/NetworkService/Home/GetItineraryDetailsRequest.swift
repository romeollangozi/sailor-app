//
//  GetItineraryDetailsRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.4.25.
//

import Foundation

struct GetItineraryDetailsRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetItineraryDetailsInput

    var path: String {
        return NetworkServiceEndpoint.getItineraryDetails
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "voyageNumber", value: input.voyageNumber),
            .init(name: "reservation-number", value: input.reservationNumber),
            .init(name: "reservation-guest-id", value: input.reservationGuestId)
        ]
    }
}

struct GetItineraryDetailsInput {
    let reservationGuestId: String
    let voyageNumber: String
    let reservationNumber: String
}

struct GetItineraryDetailsResponse: Decodable {
    let imageUrl: String?
    let title: String?
    let ship: String?
    let date: String?
    let itinerary: [ItineraryItem]?

    struct ItineraryItem: Decodable {
        let itineraryDay: Int?
        let name: String?
        let time: String?
        let note: String?
        let icon: IconType?
        let link: String?
    }

    enum IconType: String, Decodable {
        case marker
        case anchor
        case ship
    }
}

extension NetworkServiceProtocol {
    func getItineraryDetails(reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> GetItineraryDetailsResponse? {
        let request = GetItineraryDetailsRequest(input: GetItineraryDetailsInput(reservationGuestId: reservationGuestId, voyageNumber: voyageNumber, reservationNumber: reservationNumber))
        return try await self.requestV2(request, responseModel: GetItineraryDetailsResponse.self)
    }
}

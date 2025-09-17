//
//  GetEateriesSlotsRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

import Foundation

struct GetEateriesSlotsRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetEateriesSlotsRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.eateriesSlots
    }
    var method: HTTPMethod {
        return .POST
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    var bodyCodable: (any Codable)? {
        return input
    }
}

struct GetEateriesSlotsRequestBody: Codable {
    let voyageNumber: String
    let voyageId: String
    let searchSlotDate: String
    let embarkDate: String
    let debarkDate: String
    let mealPeriod: String
    let shipCode: String
    let guestCount: Int
    let venues: [Venue]
    let reservationNumber: String
    let reservationGuestId: String

    struct Venue: Codable {
        let externalId: String
        let venueId: String

        // Map "VenueId" to "venueId" in Swift using CodingKeys
        enum CodingKeys: String, CodingKey {
            case externalId
            case venueId = "VenueId"
        }
    }
}

struct GetEateriesSlotsResponse: Decodable {
    let restaurants: [Restaurant]?

    struct Restaurant: Decodable {
        let name: String?
        let externalId: String?
        let venueId: String?
		let state: String?
		let stateText: String?
		let disclaimer: String?
		let slots: [SlotResponse]?
		let appointment: AppointmentsResponse.AppointmentItemResponse?
		let appointments: AppointmentsResponse?
    }
}

extension NetworkServiceProtocol {
    func getEateriesSlots(request: GetEateriesSlotsRequestBody) async throws -> GetEateriesSlotsResponse? {
        let request = GetEateriesSlotsRequest(input: request)
        return try await self.requestV2(request, responseModel: GetEateriesSlotsResponse.self)
    }
}

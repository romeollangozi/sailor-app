//
//  GetShoreThingPortsRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import Foundation

struct GetShoreThingPortsRequest: AuthenticatedHTTPRequestProtocol {

    let reservationId: String, reservationGuestId: String, shipCode: String, voyageNumber: String

    var path: String {
        return NetworkServiceEndpoint.shorexPorts
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        let reservationId: URLQueryItem = .init(name: "reservationId", value: self.reservationId)
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
        let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
        let voyageNumber: URLQueryItem = .init(name: "voyageNumber", value: self.voyageNumber)
        return [reservationId, reservationGuestId, shipCode, voyageNumber]
    }
}

struct GetShoreThingPortsResponse: Decodable {
    let items: [ShoreThingPort]?
    let leadTime: LeadTime?
    
    struct ShoreThingPort: Decodable {
        let sequence: Int?
        let name: String?
        let code: String?
        let slug: String?
        let imageUrl: String?
        let dayType: String?
        let departureDateTime: String?
        let arrivalDateTime: String?
        let departureArrivalDateText: String?
        let departureArrivalTimeText: String?
        let guideText: String?
		let guideUrl: String?
    }
    
    struct LeadTime: Decodable {
        let title: String?
        let description: String?
        let imageUrl: String?
        let date: String?
        let isCountdownStarted: Bool?
        let timeLeftToBookingStartInSeconds: Int?
    }
}

extension NetworkServiceProtocol {
	func getShoreThingPorts(reservationId: String, reservationGuestId: String, shipCode: String, voyageNumber: String, cacheOption: CacheOption) async throws -> GetShoreThingPortsResponse? {
		let request = GetShoreThingPortsRequest(reservationId: reservationId, reservationGuestId: reservationGuestId, shipCode: shipCode, voyageNumber: voyageNumber)
        return try await self.requestV2(request, responseModel: GetShoreThingPortsResponse.self, cacheOption: cacheOption)
    }
}

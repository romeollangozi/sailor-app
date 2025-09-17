//
//  GetMyVoyageStatusRequest.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation

struct GetMyVoyageStatusRequest: AuthenticatedHTTPRequestProtocol {
    let reservationNumber: String
    let reservationGuestID: String

    var path: String {
        return NetworkServiceEndpoint.getMyVoyageStatus
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        let reservationNumber: URLQueryItem = .init(name: "reservation-number", value: self.reservationNumber)
        let reservationGuestID: URLQueryItem = .init(name: "reservation-guest-id", value: self.reservationGuestID)

        return [reservationNumber, reservationGuestID]
    }
}

struct GetMyVoyageStatusResponse: Decodable {
    let voyageStatus: String?
}

extension NetworkServiceProtocol {
    func getMyVoyageStatus(reservationNumber: String, reservationGuestID: String) async throws -> GetMyVoyageStatusResponse? {
        
        let request = GetMyVoyageStatusRequest(reservationNumber: reservationNumber, reservationGuestID: reservationGuestID)
        return try await self.requestV2(request, responseModel: GetMyVoyageStatusResponse.self)
    }
}

//
//  MarkMusterDrillVideoAsWatchedRequest.swift
//  Virgin Voyages
//
//  Created by TX on 15.4.25.
//
import Foundation

struct MarkMusterDrillVideoAsWatchedRequest: AuthenticatedHTTPRequestProtocol {
    let input: MarkMusterDrillVideoAsWatchedRequestInput
    let body: MarkMusterDrillVideoAsWatchedRequestBody

    var path: String {
        return NetworkServiceEndpoint.markMusterDrillVideoAsWatched + input.cabinNumber
    }
    
    var method: HTTPMethod {
        return .PUT
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "shipcode", value: input.shipcode),
            .init(name: "device", value: input.device)
        ]
    }
    
    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }
}

struct MarkMusterDrillVideoAsWatchedRequestBody: Encodable {
    var reservationGuestIds: [String]?
}

struct MarkMusterDrillVideoAsWatchedRequestInput {
    let shipcode: String
    let cabinNumber: String
    let device: String = "app"
}


extension NetworkServiceProtocol {
    func markMusterDrillVideoAsWatched(shipcode: String, cabinNumber: String, reservationGuestId: String) async throws -> EmptyResponse? {

        let request = MarkMusterDrillVideoAsWatchedRequest(
            input: MarkMusterDrillVideoAsWatchedRequestInput(
                shipcode: shipcode,
                cabinNumber: cabinNumber
            ),
            body: MarkMusterDrillVideoAsWatchedRequestBody(
                reservationGuestIds: [reservationGuestId]
            )
        )
        
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}


//
//  SaveCitizenshipRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 8.9.25.
//

import Foundation

struct SaveCitizenshipRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String?
    var body: SaveCitizenshipBody?

    var path: String {
        return NetworkServiceEndpoint.saveCitizenship
    }

    var method: HTTPMethod {
        return .PUT
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }
}

struct SaveCitizenshipBody: Encodable {
    var citizenshipCountryCode: String?
    var reservationGuestId: String?
}

extension NetworkServiceProtocol {
    func saveCitizenship(_ body: SaveCitizenshipBody) async throws -> EmptyResponse {
        let request = SaveCitizenshipRequest(
            reservationGuestId: body.reservationGuestId,
            body: body
        )
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}

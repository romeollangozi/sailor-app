//
//  GetMyDocumentsRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.3.25.
//

import Foundation

struct GetMyDocumentsRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String

    var path: String {
        return NetworkServiceEndpoint.getMyDocuments
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        let reservationGuestId = [URLQueryItem(name: "reservationGuestId", value: reservationGuestId)]
        return reservationGuestId
    }
}

struct GetMyDocumentsResponse: Decodable {
    let documents: [Document]?
    let hasPostVoyagePlans: Bool?

    struct Document: Decodable {
        let id: String?
        let name: String?
        let documentPhotoUrl: String?
        let documentCode: String?
        let categoryCode: String?
        let documentType: String?
        let isSecure: Bool?
        let moderationErrors: [String]?
    }
}

extension NetworkServiceProtocol {
    func getMyDocuments(reservationGuestId: String) async throws -> GetMyDocumentsResponse? {
        let request = GetMyDocumentsRequest(reservationGuestId: reservationGuestId)
        return try await self.requestV2(request, responseModel: GetMyDocumentsResponse.self)
    }
}

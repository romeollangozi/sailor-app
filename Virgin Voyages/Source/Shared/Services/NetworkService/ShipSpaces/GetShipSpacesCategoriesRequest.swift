//
//  GetShipSpacesRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.1.25.
//

import Foundation

struct GetShipSpacesCategoriesRequest: AuthenticatedHTTPRequestProtocol {
    let reservationId: String
    let guestId: String
    let shipCode: String
    
    var path: String {
        return NetworkServiceEndpoint.shipSpacesCategories
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationId: URLQueryItem = .init(name: "reservationId", value: self.reservationId)
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.guestId)
        let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
        return [reservationId, reservationGuestId, shipCode]
    }
    
}

struct GetShipSpacesResponse: Decodable {
    struct Category: Decodable {
        let code: String?
        let name: String?
        let imageUrl: String?
    }
    
    let header: String?
    let subHeader: String?
    let shipMapText: String?
    let categories: [Category]?
}

extension NetworkServiceProtocol {
    func getShipSpaces(reservationId: String, guestId: String, shipCode: String, cacheOption: CacheOption = .noCache()) async throws -> GetShipSpacesResponse? {
        let request = GetShipSpacesCategoriesRequest(reservationId: reservationId, guestId: guestId, shipCode: shipCode)
        return try await self.requestV2(request, responseModel: GetShipSpacesResponse.self, cacheOption: cacheOption)
    }
}

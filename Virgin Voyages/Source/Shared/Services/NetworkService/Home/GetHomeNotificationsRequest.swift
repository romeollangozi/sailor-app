//
//  GetHomeNotificationsRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.3.25.
//

import Foundation

struct GetHomeNotificationsRequest: AuthenticatedHTTPRequestProtocol {
    let reservationGuestId: String
    let reservationNumber: String
    let voyageNumber: String
    
    var path: String {
        return NetworkServiceEndpoint.homeNotification
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "reservationGuestId", value: self.reservationGuestId), URLQueryItem(name: "reservationNumber", value: self.reservationNumber),
            URLQueryItem(name: "voyageNumber", value: self.voyageNumber)]
    }
}

struct GetHomeNotificationsResponse: Decodable {
    let unReadCount: Int?
    let title: String?
    let summary: String?
    let createdAt: String?
}

extension NetworkServiceProtocol {
    func getHomeNotifications(reservationGuestId: String, reservationNumber: String, voyageNumber: String) async throws -> GetHomeNotificationsResponse? {
        let request = GetHomeNotificationsRequest(reservationGuestId:reservationGuestId, reservationNumber:reservationNumber,
            voyageNumber: voyageNumber)
        
        return try await self.requestV2(request, responseModel: GetHomeNotificationsResponse.self)
    }
}


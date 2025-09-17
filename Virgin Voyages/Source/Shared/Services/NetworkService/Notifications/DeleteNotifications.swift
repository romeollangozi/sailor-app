//
//  DeleteNotifications.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import Foundation

struct DeleteNotificationsRequest: AuthenticatedHTTPRequestProtocol {
    let reservationGuestId: String
    let voyageNumber: String
    
    var path: String {
        return NetworkServiceEndpoint.notifications
    }
    
    var method: HTTPMethod {
        return .DELETE
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "reservationGuestId", value: self.reservationGuestId), URLQueryItem(name: "voyageNumber", value: self.voyageNumber)]
    }
}

extension NetworkServiceProtocol {
    func deleteAllNotifications(reservationGuestId: String, voyageNumber: String) async throws -> EmptyResponse? {
        let request = DeleteNotificationsRequest(reservationGuestId:reservationGuestId, voyageNumber: voyageNumber)
        
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}


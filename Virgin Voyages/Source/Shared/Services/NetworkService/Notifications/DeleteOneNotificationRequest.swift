//
//  DeleteOneNotificationRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 8/1/25.
//

import Foundation

struct DeleteOneNotificationRequest: AuthenticatedHTTPRequestProtocol {
    
    let notificationId: String
    let voyageNumber: String
    
    var path: String {
        return NetworkServiceEndpoint.notifications + "/\(notificationId)"
    }
    
    var method: HTTPMethod {
        return .DELETE
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "voyageNumber",
                             value: self.voyageNumber)]
    }
}

extension NetworkServiceProtocol {
    func deleteOneNotification(notificationId: String, voyageNumber: String) async throws -> EmptyResponse? {
        
        let request = DeleteOneNotificationRequest(notificationId: notificationId,
                                                   voyageNumber: voyageNumber)
        
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}

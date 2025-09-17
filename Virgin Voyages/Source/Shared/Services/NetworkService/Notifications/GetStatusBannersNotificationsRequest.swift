//
//  GetStatusBannersNotificationsRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/29/25.
//

import Foundation

struct GetStatusBannersNotificationsRequest: AuthenticatedHTTPRequestProtocol {
    
    let voyageNumber: String
    
    var path: String {
        return NetworkServiceEndpoint.statusBannerNotifications
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "voyageNumber",
                             value: self.voyageNumber)]
    }
}

struct GetStatusBannersNotificationsResponse: Decodable {
    let items: [StatusBannerNotificationItem]?
    
    struct StatusBannerNotificationItem: Decodable {
        let id: String?
        let type: String?
        let data: String?
        let title: String?
        let description: String?
        let isRead: Bool?
        let createdAt: String?
        let isTappable: Bool?
        let isDismissable: Bool?
    }
    
}

extension NetworkServiceProtocol {
    
    func getStatusBannerNotifications(voyageNumber: String) async throws -> GetStatusBannersNotificationsResponse? {
        
        let request = GetStatusBannersNotificationsRequest(voyageNumber: voyageNumber)
        
        return try await self.requestV2(request, responseModel: GetStatusBannersNotificationsResponse.self)
    }
    
}

//
//  GetHomeUnreadMessagesRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/28/25.
//

import Foundation

struct GetHomeUnreadMessagesRequest: AuthenticatedHTTPRequestProtocol {
    
    let voyageNumber: String //SC2505045NCZ
    
    var path: String {
        return NetworkServiceEndpoint.getHomeUnreadMessages
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "voyageNumber", value: voyageNumber)
        ]
    }
}

struct GetHomeUnreadMessagesResponse: Codable {
    let total: Int?
}

extension NetworkServiceProtocol {
    
    func getHomeUnreadMessages(voyageNumber: String) async throws -> GetHomeUnreadMessagesResponse? {
        
        let request = GetHomeUnreadMessagesRequest(voyageNumber: voyageNumber)
        
        return try await self.requestV2(request, responseModel: GetHomeUnreadMessagesResponse.self)
        
    }
}

// MARK: - Mock Response

extension GetHomeUnreadMessagesResponse {
    
    static func mock() -> GetHomeUnreadMessagesResponse {
        
        return GetHomeUnreadMessagesResponse(total: 2)
        
    }
}

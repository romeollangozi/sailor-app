//
//  MarkNotificationsAsReadRequest.swift
//  Virgin Voyages
//
//  Created by TX on 26.11.24.
//

import Foundation

struct MarkNotificationsAsReadRequest: AuthenticatedHTTPRequestProtocol {
    let input: MarkNotificationsAsReadRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.markNotificationMessagesAsRead
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
        
    var bodyCodable: (any Codable)? {
        return input
    }
}

struct MarkNotificationsAsReadRequestBody : Codable {
    let Read_Time: Int
    let NotificationIDs: [String]
}

extension NetworkServiceProtocol {
    func markNotificationsAsReadRequest(input: MarkNotificationsAsReadRequestBody) async throws -> ApiResponse<EmptyResponse> {
        let request = MarkNotificationsAsReadRequest(input: input)
        return await self.request(request, responseModel: EmptyResponse.self)
    }
}

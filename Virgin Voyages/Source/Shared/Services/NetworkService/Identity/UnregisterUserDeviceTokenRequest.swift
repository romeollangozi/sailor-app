//
//  UnregisterUserDeviceTokenRequest.swift
//  Virgin Voyages
//
//  Created by TX on 3.12.24.
//

import Foundation

struct UnregisterUserDeviceTokenRequest: AuthenticatedHTTPRequestProtocol {
    let input: UnregisterUserDeviceTokenBody
    
    var path: String {
        return NetworkServiceEndpoint.unregisterDeviceToken
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

struct UnregisterUserDeviceTokenBody : Codable {
    let DeviceID: String
}

extension NetworkServiceProtocol {
    func unregisterDeviceTokenForPushNotifications(input: UnregisterUserDeviceTokenBody) async -> ApiResponse<EmptyResponse> {
        let request = UnregisterUserDeviceTokenRequest(input: input)
        return await self.request(request, responseModel: EmptyResponse.self)
    }
}

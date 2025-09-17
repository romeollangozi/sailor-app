//
//  RegisterUserDeviceTokenRequest.swift
//  Virgin Voyages
//
//  Created by TX on 21.11.24.
//

import Foundation

struct RegisterUserDeviceTokenRequest: AuthenticatedHTTPRequestProtocol {
    let input: RegisterUserDeviceTokenBody
    
    var path: String {
        return NetworkServiceEndpoint.registerDeviceToken
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

struct RegisterUserDeviceTokenBody : Codable {
    let DeviceID: String
    let FireBaseToken: String
}

extension NetworkServiceProtocol {
    func registerDeviceTokenForPushNotifications(input: RegisterUserDeviceTokenBody) async throws -> EmptyResponse {
        let request = RegisterUserDeviceTokenRequest(input: input)
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}

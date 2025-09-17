//
//  CreateBeaconRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

struct CreateBeaconRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: CreateBeaconRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.beacon
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

struct CreateBeaconRequestBody: Codable {
    let reservationGuestId: String
    let beaconId: String?
}

struct CreateBeaconResponse: Codable {
    let beaconId: String?
}

extension NetworkServiceProtocol {
    
    func createBeacon(request: CreateBeaconRequestBody) async throws -> CreateBeaconResponse {
        
        let request = CreateBeaconRequest(input: request)
        return try await self.requestV2(request,
                                        responseModel: CreateBeaconResponse.self)
    }
}

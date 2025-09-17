//
//  CreateMaintenanceServiceRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/1/25.
//

import Foundation

struct CreateMaintenanceServiceRequest: AuthenticatedHTTPRequestProtocol {
    let input: CreateMaintenanceServiceRequestBody
    let shipCode: String
    
    var path: String {
        return NetworkServiceEndpoint.createMaintenanceServiceRequest
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
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "shipcode", value: shipCode),
            .init(name: "device", value: "app")
        ]
    }
    
}


struct CreateMaintenanceServiceRequestBody: Codable {
    let reservationGuestId: String
    let stateroom: String
    let incidentCategoryCode: String
}

struct CreateMaintenanceServiceResponse: Codable {
    let incidentId: String?
}

extension NetworkServiceProtocol {
    
    func createMaintenanceServiceRequest(request: CreateMaintenanceServiceRequestBody,
                                         shipCode: String) async throws -> CreateMaintenanceServiceResponse {
        
        let request = CreateMaintenanceServiceRequest(input: request, shipCode: shipCode)
        return try await self.requestV2(request, responseModel: CreateMaintenanceServiceResponse.self)
    }
    
}

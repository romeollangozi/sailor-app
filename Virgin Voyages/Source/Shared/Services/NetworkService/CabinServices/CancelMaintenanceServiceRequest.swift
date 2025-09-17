//
//  CancelMaintenanceServiceRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/2/25.
//

import Foundation

struct CancelMaintenanceServiceRequest: AuthenticatedHTTPRequestProtocol {
    let input: CancelMaintenanceServiceRequestBody
    let shipCode: String
    
    var path: String {
        return NetworkServiceEndpoint.cancelMaintenanceServiceRequest
    }
    
    var method: HTTPMethod {
        return .PUT
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

struct CancelMaintenanceServiceRequestBody: Codable {
    let incidentId: String
    let incidentCategoryCode: String
    let stateroom: String
    let reservationGuestId: String
}

extension NetworkServiceProtocol {
    
    func cancelMaintenanceService(request: CancelMaintenanceServiceRequestBody,
                                  shipCode: String) async throws -> EmptyResponse? {
        
        let request = CancelMaintenanceServiceRequest(input: request,
                                                      shipCode: shipCode)
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
    
}

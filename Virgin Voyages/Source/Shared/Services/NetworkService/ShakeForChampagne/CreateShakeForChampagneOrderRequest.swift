//
//  CreateShakeForChampagneOrderRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/21/25.
//

import Foundation

struct CreateShakeForChampagneOrderRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: CreateShakeForChampagneOrderRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.shakeForChampagneOrder
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

struct CreateShakeForChampagneOrderRequestBody: Codable {
    let reservationGuestId: String
    let quantity: Int
}

struct CreateShakeForChampagneOrderResponse: Decodable {
    let orderId: String?
}

extension NetworkServiceProtocol {
    
    func createShakeForChampagneOrder(request: CreateShakeForChampagneOrderRequestBody) async throws -> CreateShakeForChampagneOrderResponse {
        
        let request = CreateShakeForChampagneOrderRequest(input: request)
        return try await self.requestV2(request, responseModel: CreateShakeForChampagneOrderResponse.self)
        
    }
}

//
//  CancelShakeForChampagneOrderRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/21/25.
//

import Foundation

struct CancelShakeForChampagneOrderRequest: AuthenticatedHTTPRequestProtocol {
    
    let orderId: String
    
    var path: String {
        return NetworkServiceEndpoint.shakeForChampagneCancelOrder + "/\(orderId)"
    }
    
    var method: HTTPMethod {
        return .DELETE
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

}

struct CancelShakeForChampagneOrderResponse: Codable {
    let orderId: String?
    let message: String?
}

extension NetworkServiceProtocol {
    
    func cancelShakeForChampagneOrder(orderId: String) async throws -> CancelShakeForChampagneOrderResponse? {
        
        let request = CancelShakeForChampagneOrderRequest(orderId: orderId)
        return try await self.requestV2(request, responseModel: CancelShakeForChampagneOrderResponse.self)
        
    }
    
}

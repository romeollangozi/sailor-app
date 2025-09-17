//
//  UpdateHealthCheckDetailRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

struct UpdateHealthCheckDetailRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: UpdateHealthCheckDetailRequestBody
    let reservationGuestId: String
    let reservationId: String
    
    var path: String {
        return NetworkServiceEndpoint.updateHealthCheckDetail
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
            .init(name: "reservation-guest-id", value: reservationGuestId),
            .init(name: "reservation-id", value: reservationId)
        ]
    }
    
}

// MARK: - UpdateHealthCheckDetailRequestBody

struct UpdateHealthCheckDetailRequestBody: Codable {
    let healthQuestions: [HealthQuestion]
    let signForOtherGuests: [String]
    
    struct HealthQuestion: Codable {
        let questionCode: String
        let selectedOption: String
    }
}

// MARK: - UpdateHealthCheckDetailResponse
 
struct UpdateHealthCheckDetailResponse: Codable {
    let isHealthCheckComplete: Bool?
    let isFitToTravel: Bool?
    let healthCheckFailedPage: HealthCheckFailedPage?
    
    struct HealthCheckFailedPage: Codable {
        let imageURL: String?
        let title: String?
        let description: String?
    }
}

// MARK: - NetworkServiceProtocol

extension NetworkServiceProtocol {
    
    func updateHealthCheckDetail(input: UpdateHealthCheckDetailRequestBody,
                                 reservationGuestId: String,
                                 reservationId: String) async throws -> UpdateHealthCheckDetailResponse {
        
        let request = UpdateHealthCheckDetailRequest(input: input,
                                                     reservationGuestId: reservationGuestId,
                                                     reservationId: reservationId)
        
        return try await self.requestV2(request, responseModel: UpdateHealthCheckDetailResponse.self)
        
    }
    
}


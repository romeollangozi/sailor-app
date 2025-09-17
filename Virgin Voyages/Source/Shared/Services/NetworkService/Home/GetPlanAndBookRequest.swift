//
//  GetPlanAndBookRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/10/25.
//

import Foundation

struct GetPlanAndBookRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetPlanAndBookDataInput
    
    var path: String {
        return NetworkServiceEndpoint.getPlanAndBook
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "shipCode", value: input.shipCode),
            .init(name: "reservation-id", value: input.reservationId),
            .init(name: "reservation-number", value: input.reservationNumber),
            .init(name: "reservation-guest-id", value: input.reservationGuestId),
            .init(name: "sailing-mode", value: input.sailingMode)
        ]
    }
    
}

struct GetPlanAndBookDataInput {
    let shipCode: String
    let reservationId: String
    let reservationNumber: String
    let reservationGuestId: String
    let sailingMode: String
}

struct GetPlanAndBookResponse: Decodable {
    
    let bookActivities: [VoyageBookActivity]?
    let exploreActivities: [VoyageExploreActivity]?
    
    struct VoyageExploreActivity: Decodable {
        let imageUrl: String?
        let name: String?
        let code: String?
        let layoutType: String?
    }
    
    struct VoyageBookActivity: Decodable {
        let imageUrl: String?
        let name: String?
        let bookableType: String?
        let layoutType: String?
    }
    
}

extension NetworkServiceProtocol {
    
    func getPlanAndBookContent(shipCode: String,
                               reservationId: String,
                               reservationNumber: String,
                               reservationGuestId: String,
                               sailingMode: String) async throws -> GetPlanAndBookResponse? {
                
        let request = GetPlanAndBookRequest(input: GetPlanAndBookDataInput(shipCode: shipCode,
                                                                           reservationId: reservationId,
                                                                           reservationNumber: reservationNumber,
                                                                           reservationGuestId: reservationGuestId,
                                                                           sailingMode: sailingMode))
        
        return try await self.requestV2(request, responseModel: GetPlanAndBookResponse.self)
        
    }
}


// MARK: - Mock Response

extension GetPlanAndBookResponse {
    
    static func mock() -> GetPlanAndBookResponse {
        
        return GetPlanAndBookResponse(bookActivities: [
            VoyageBookActivity(imageUrl: "",
                               name: "Luxury Spa Treatment",
                               bookableType: "Treatment",
                               layoutType: "Full")
        ], exploreActivities: [
            VoyageExploreActivity(imageUrl: "",
                                  name: "Eateries",
                                  code: "Eateries",
                                  layoutType: "Square"),
            VoyageExploreActivity(imageUrl: "",
                                  name: "BeautyAndBody",
                                  code: "Beauty--And--Body",
                                  layoutType: "Square")
        ])
    }
}

//
//  GetShipSpaceCategoryDetailsRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import Foundation

struct GetShipSpaceCategoryDetailsRequest: AuthenticatedHTTPRequestProtocol {
    let shipSpaceCategoryCode: String
    let guestId: String
    let shipCode: String
    
    var path: String {
        guard let encodedCategoryCode = shipSpaceCategoryCode.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return "\(NetworkServiceEndpoint.shipSpaceCategoryDetails)/\(shipSpaceCategoryCode)"
        }
        return "\(NetworkServiceEndpoint.shipSpaceCategoryDetails)/\(encodedCategoryCode)"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.guestId)
        let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
        return [reservationGuestId, shipCode]
    }
}

struct GetShipSpaceCategoryResponse: Decodable {
    struct ShipSpace: Decodable {
        struct OpeningTime: Decodable {
            let fromToDay: String?
            let fromToTime: String?
        }
        
        struct TreatmentCategory: Decodable {
            struct TreatmentSubCategory: Decodable {
                struct Treatment: Decodable {
                    let id: String?
                    let name: String?
                    let imageUrl: String?
                }
                let name: String?
                let treatments: [Treatment]?
            }
            let name: String?
            let subCategories: [TreatmentSubCategory]?
        }
        
        let id: String?
        let imageUrl: String?
        let landscapeThumbnailUrl: String?
        let name: String?
        let location: String?
        let introduction: String?
        let shortDescription: String?
        let longDescription: String?
        let needToKnows: [String]?
        let editorialBlocks: [String]?
        let openingTimes: [OpeningTime]?
        let treatmentCategories: [TreatmentCategory]?
    }
    
    struct LeadTime: Decodable {
        let title: String?
        let description: String?
        let imageUrl: String?
        let date: String?
        let isCountdownStarted: Bool?
        let timeLeftToBookingStartInSeconds: Int?
    }
    
    let imageUrl: String?
    let header: String?
    let subHeader: String?
    let shipSpaces: [ShipSpace]?
    let leadTime: LeadTime?
}

extension NetworkServiceProtocol {
    func getShipSpaceCategoryDetails(shipSpaceCategoryCode: String, guestId: String, shipCode: String, cacheOption: CacheOption = .noCache()) async throws -> GetShipSpaceCategoryResponse? {
        let request = GetShipSpaceCategoryDetailsRequest(shipSpaceCategoryCode: shipSpaceCategoryCode, guestId: guestId, shipCode: shipCode)
		return try await self.requestV2(request, responseModel: GetShipSpaceCategoryResponse.self, cacheOption: cacheOption)
    }
}

//
//  GetEateriesOpeningTimesRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

import Foundation

struct GetEateriesOpeningTimesRequest: AuthenticatedHTTPRequestProtocol {
    let reservationId: String
    let reservationGuestId: String
    let shipCode: String
    let reservationNumber: String
    let selectedDate: String
   
    var path: String {
        return NetworkServiceEndpoint.eateriesOpeningTimes
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    var queryItems: [URLQueryItem]? {
        let reservationId: URLQueryItem = .init(name: "reservationId", value: self.reservationId)
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
        let shipCode: URLQueryItem = .init(name: "shipCode", value: self.shipCode)
        let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: self.reservationNumber)
        let spaceName: URLQueryItem = .init(name: "spaceName", value: "Eateries")
        let selectedDate: URLQueryItem = .init(name: "selectedDate", value: self.selectedDate)
        
        return [reservationId, reservationGuestId, shipCode, reservationNumber, spaceName, selectedDate]
    }
}

struct GetEateriesOpeningTimesResponse: Codable {
    struct Venue: Codable {
        struct Restaurant: Codable {
            struct OperationalHours: Codable {
                let fromTime: String?
                let toTime: String?
            }
            
            let name: String?
            let externalId: String?
            let deckLocation: String?
            let operationalHours: [OperationalHours]?
            let actionUrl: String?
            let state: String?
        }
        
        let name: String?
        let restaurants: [Restaurant]?
    }
    
    struct CMSContent: Codable {
        struct Text: Codable {
            let openingTimesHeading: String?
        }
        
        let text: Text?
    }
    
    let venues: [Venue]?
    let isPreVoyageBookingStopped: Bool?
    let cmsContent: CMSContent?
}

extension NetworkServiceProtocol {
    func getEateriesOpeningTimes(reservationId: String,
                                 reservationGuestId: String,
                                 shipCode: String,
                                 reservationNumber: String,
                                 selectedDate: String) async throws -> GetEateriesOpeningTimesResponse? {
        let request = GetEateriesOpeningTimesRequest(reservationId: reservationId,
                                                     reservationGuestId: reservationGuestId,
                                                     shipCode: shipCode,
                                                     reservationNumber:reservationNumber,
                                                     selectedDate: selectedDate)
        
        return try await self.requestV2(request, responseModel: GetEateriesOpeningTimesResponse.self)
    }
}

//
//  GetMyVoyageHeaderRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.2.25.
//

import Foundation

struct GetMyVoyageHeaderRequest: AuthenticatedHTTPRequestProtocol {
    let reservationGuestId: String
    let reservationNumber: String
    
    var path: String {
        return NetworkServiceEndpoint.myVoyageHeader
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
        let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: self.reservationNumber)
        
        return [reservationGuestId, reservationNumber]
    }
}

struct GetMyVoyageHeaderRequestResponse: Decodable {
    let imageUrl: String?
    let type: GetMyVoyageHeaderRequestResponse.MyVoyageType?
    let name: String?
    let profileImageUrl: String?
    let cabinNumber: String?
    let lineUpOpeningDateTime: String?
    let isLineUpOpened: Bool?
    
    enum MyVoyageType: String, Decodable {
        case standard = "Standard"
        case priority = "Priority"
        case rockStar = "RockStar"
        case megaRockStar = "MegaRockStar"
    }
}

extension NetworkServiceProtocol {
	func getMyVoyageHeader(reservationGuestId: String, reservationNumber: String, cacheOption: CacheOption) async throws -> GetMyVoyageHeaderRequestResponse {
		let request = GetMyVoyageHeaderRequest(reservationGuestId:reservationGuestId, reservationNumber:reservationNumber)
        
        return try await self.requestV2(request, responseModel: GetMyVoyageHeaderRequestResponse.self, cacheOption: cacheOption)
    }
}

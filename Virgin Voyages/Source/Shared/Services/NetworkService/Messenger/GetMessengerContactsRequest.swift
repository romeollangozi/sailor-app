//
//  GetMessengerContactsRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.10.24.
//

import Foundation

struct GetMessengerContactsRequest: AuthenticatedHTTPRequestProtocol {
    let reservationId: String
    let personId: String
    let personTypeCode: String = "RG"
    var path: String {
        return NetworkServiceEndpoint.getMessengerContacts
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    var queryItems: [URLQueryItem]? {
        let reservationId: URLQueryItem = .init(name: "reservationId", value: self.reservationId)
        let personId: URLQueryItem = .init(name: "personId", value: self.personId)
        let personTypeCode: URLQueryItem = .init(name: "personTypeCode", value: self.personTypeCode)
        return [reservationId, personId, personTypeCode]
    }
}

struct GetMessengerContactsResponse: Decodable {
    let cabinMates: [ContactItem]?
    let sailorMates: [ContactItem]?
    let directoryDetails: [DirectoryItem]?
    let isDefaultContactsDelete: Bool?
    
    struct ContactItem: Codable {
        let name: String?
        let photoUrl: String?
        let personId: String?
        let reservationId: String?
        let isEventVisible: Bool?
    }
    
    struct DirectoryItem: Codable {
        let assetKeyName: String?
        let phoneNumber: String?
        let isMessenger: Bool?
        let isEnable: Bool?
    }
}

extension NetworkServiceProtocol {
	func getMessengerContacts(reservationId: String, personId: String, cacheOption: CacheOption) async throws -> GetMessengerContactsResponse? {
        let request = GetMessengerContactsRequest(reservationId: reservationId, personId: personId)
		return try await self.requestV2(request, responseModel: GetMessengerContactsResponse.self, cacheOption: cacheOption)
    }
}

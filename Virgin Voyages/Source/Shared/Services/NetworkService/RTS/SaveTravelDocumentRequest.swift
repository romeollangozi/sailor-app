//
//  SaveTravelDocumentRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 12.3.25.
//

import Foundation

struct SaveTravelDocumentRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String
	var embarkDate: String
    var debarkDate: String
    var id: String?
    
    var body: SaveTravelDocumentBody
    
    var path: String {
        return NetworkServiceEndpoint.saveTravelDocuments
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        var items = [
			URLQueryItem(name: "reservationGuestId", value: reservationGuestId),
			URLQueryItem(name: "embarkDate", value: embarkDate),
            URLQueryItem(name: "debarkDate", value: debarkDate)
		]
        if let id = id {
            items.append(URLQueryItem(name: "id", value: id))
        }
        return items
    }
    
    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }
    
}

struct DocumentCombinedRule: Codable, Equatable, Hashable {
    let sourceDocumentType: String?
    let destinationDocumentType: String?
    let field: String?
    let saveType: String?
}

struct SaveTravelDocumentBody: Encodable {
    let fields: [String: String]
    let documentCombinedRules: [DocumentCombinedRule]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)

        for (key, field) in fields {
            try container.encode(field, forKey: DynamicCodingKeys(stringValue: key))
        }

        try container.encode(documentCombinedRules, forKey: DynamicCodingKeys(stringValue: "documentCombinedRules"))
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { nil }
        init?(intValue: Int) { return nil }
    }
}

struct SaveTravelDocResponse: Decodable {
    var identificationId: String?
    var hasPostVoyagePlans: Bool?
}

extension NetworkServiceProtocol {
	func saveTravelDocument(reservationGuestId: String, embarkDate: String, debarkDate: String, id: String?, body: SaveTravelDocumentBody) async throws -> SaveTravelDocResponse? {
        let request = SaveTravelDocumentRequest(reservationGuestId: reservationGuestId, embarkDate: embarkDate, debarkDate: debarkDate, id: id, body: body)
        return try await self.requestV2(request, responseModel: SaveTravelDocResponse.self)
    }
}

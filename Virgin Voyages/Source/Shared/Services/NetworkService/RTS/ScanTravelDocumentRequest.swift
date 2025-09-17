//
//  ScanTravelDocumentRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 3.3.25.
//

import Foundation

struct ScanTravelDocumentRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String
    var id: String?
    var ocrValidation: Bool = true
    var body: TravelDocumentBody?

    var path: String {
        return NetworkServiceEndpoint.getTravelDocuments
    }

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        var items = [URLQueryItem(name: "reservationGuestId", value: reservationGuestId)]
        if let id = id {
            items.append(URLQueryItem(name: "id", value: id))
        }
        if !ocrValidation {
            items.append(URLQueryItem(name: "ocrValidation", value: "\(ocrValidation)"))
        }
        return items
    }

    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }

    var timeoutInterval: TimeInterval {
        return 120.0
    }
}

struct TravelDocumentBody: Encodable {
    let photoContent: String?
    let documentPhotoId: String?
    let documentBackPhotoId: String?
    let documentCode: String?
    let categoryCode: String?
    let documentType: String?
}

struct ScanTravelDocumentResponse: Decodable {
    let title: String?
    let description: String?
    let id: String?
    let moderationErrors: [String]?
    let fields: [Field]?
    let isScanable: Bool?
    let isTwiceSide: Bool?
    let scanFormatType: String?
    let isCapturable: Bool?
    let isAlreadyUploaded: Bool?
    let documentExpirationWarnConfig: DocumentExpirationWarnConfig?
    let documentCombinedRules: [DocumentCombinedRule]?

    struct Field: Decodable {
        let label: String?
        let name: String?
        let type: String?
        let value: String?
        let readonly: Bool?
        let hidden: Bool?
        let required: Bool?
        let isSecure: Bool?
        let referenceName: String?
        let maskedValue: String?
    }
    
    struct DocumentExpirationWarnConfig: Decodable {
        let documentExpirationInMonths: Int?
        let title: String?
        let description: String?
    }
    
    struct DocumentCombinedRule: Codable, Equatable, Hashable {
        let sourceDocumentType: String?
        let destinationDocumentType: String?
        let field: String?
        let saveType: String?
    }
}

extension NetworkServiceProtocol {
    func scanTravelDocument(reservationGuestId: String, id: String?, ocrValidation: Bool, body: TravelDocumentBody?) async throws -> ScanTravelDocumentResponse? {
        let request = ScanTravelDocumentRequest(reservationGuestId: reservationGuestId, id: id, ocrValidation: ocrValidation, body: body)
        return try await self.requestV2(request, responseModel: ScanTravelDocumentResponse.self)
    }
}

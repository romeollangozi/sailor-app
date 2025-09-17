//
//  DeleteDocumentRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

struct DeleteDocumentRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String
    var body: DeleteTravelDocBody?

    var path: String {
        return "/rts-bff/traveldocuments/v1"
    }

    var method: HTTPMethod {
        return .PUT
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "reservation-guest-id", value: reservationGuestId)
        ]
    }

    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }
}

struct DeleteTravelDocBody: Encodable {
    var travelDocumentsDetail: DeleteTravelDocumentsDetail?
}

struct DeleteTravelDocumentsDetail: Encodable {
    var countryOfResidenceCode: String?
    var identificationDocuments: [[String: InputValue]?]?
    var visaInfoList: [[String: InputValue]?]?
}

struct DeleteDocumentResponse: Decodable {
    let tasksCompletionPercentage: TasksCompletionPercentage?
    let fieldErrors: FieldErrors?
    let enablePostCruiseTab: Bool?

    struct TasksCompletionPercentage: Decodable {
        let security: Int?
        let travelDocuments: Int?
        let paymentMethod: Int?
        let pregnancy: Int?
        let voyageContract: Int?
        let emergencyContact: Int?
        let embarkationSlotSelection: Int?
    }

    struct FieldErrors: Decodable {
        let fieldErrors: [String]?
    }
}
extension NetworkServiceProtocol {
    func deleteTravelDocument(reservationGuestId: String, body: DeleteTravelDocBody?) async throws -> DeleteDocumentResponse? {
        let request = DeleteDocumentRequest(reservationGuestId: reservationGuestId, body: body)
        return try await self.requestV2(request, responseModel: DeleteDocumentResponse.self)
    }
}

enum InputValue: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(InputValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let b): try container.encode(b)
        case .string(let s): try container.encode(s)
        }
    }
}

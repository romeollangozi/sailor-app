//
//  GetTravelDocumentsRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import Foundation

struct GetTravelDocumentsRequest: AuthenticatedHTTPRequestProtocol {
    var reservationGuestId: String

    var path: String {
        return NetworkServiceEndpoint.getTravelDocuments
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: self.reservationGuestId)
        return [reservationGuestId]
    }
}

struct GetTravelDocumentsResponse: Decodable {
    let title: String?
    let description: String?
    let citizenship: String?
    let citizenshipType: String?
    let actionText: String?
    let hasPostVoyagePlans: Bool?
    let debarkCountryName: String?
    let govermentLink: String?
    let documentStages: [DocumentStage]?

    struct DocumentStage: Decodable {
        let title: String?
        let description: String?
        let isCompleted: Bool?
        let isChoisable: Bool?
        let documents: [Document]?
    }

    struct Document: Decodable {
        let name: String?
        let type: String?
        let code: String?
        let categoryCode: String?
        let categoryId: String?
        let isScanable: Bool?
        let isCapturable: Bool?
        let isTwiceSide: Bool?
        let isAlreadyUploaded: Bool?
        let scanFormatType: String?
        let documentId: String?
        let mrzField: String?
        let isMultiCategoryDocument: Bool?
        let categoryDetails: CategoryDetail?
    }
    
    struct CategoryDetail: Decodable {
        let title: String?
        let description: String?
        let categories: [Document]?
    }
}

extension NetworkServiceProtocol {
    func getTravelDocuments(reservationGuestId:String) async throws -> GetTravelDocumentsResponse? {
        let request = GetTravelDocumentsRequest(reservationGuestId: reservationGuestId)
        return try await self.requestV2(request, responseModel: GetTravelDocumentsResponse.self)
    }
}

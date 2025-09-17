//
//  BookSlotRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

struct BlockSlotRequest: AuthenticatedHTTPRequestProtocol {
    let input: BlockSlotRequestRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.bookSlot
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
        
    var bodyCodable: (any Codable)? {
        return input
    }
}

struct BlockSlotRequestRequestBody: Codable {
    let isPayWithSavedCard: Bool?
    let loggedInReservationGuestId: String?
    let reservationNumber: String?
    let isGift: Bool?
    let accessories: [String]?
    let currencyCode: String?
    let operationType: String?
    let categoryCode: String?
    let voyageNumber: String?
    let extraGuestCount: Int?
    let personDetails: [PersonDetail]?
    let activityCode: String?
    let shipCode: String?
    let activitySlotCode: String?
    let startDate: String?

    struct PersonDetail: Codable {
        let personId: String?
        let reservationNumber: String?
        let guestId: String?
    }
}

struct BlockSlotResponse: Decodable {
    let appointmentId: String?
    let appointmentLinkId: String?
    let paymentStatus: String?
    let message: Error?

    struct Error: Decodable {
        let status: Int?
        let title: String?
    }
}

extension NetworkServiceProtocol {
    func bookSlot(request: BlockSlotRequestRequestBody) async throws -> BlockSlotResponse? {
        let request = BlockSlotRequest(input: request)
        return try await self.requestV2(request, responseModel: BlockSlotResponse.self)
    }
}

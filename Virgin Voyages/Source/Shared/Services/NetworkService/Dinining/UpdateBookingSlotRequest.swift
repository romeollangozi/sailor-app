//
//  UpdateBookingRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

struct UpdateBookingSlotRequest: AuthenticatedHTTPRequestProtocol {
    let input: UpdateBookingRequestRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.updateBookSlot
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

struct UpdateBookingRequestRequestBody: Codable {
    let isPayWithSavedCard: Bool
    let loggedInReservationGuestId: String
    let reservationNumber: String
    let isGift: Bool
    let accessories: [String]
    let currencyCode: String
    let operationType: String
    let categoryCode: String
    let voyageNumber: String
    let extraGuestCount: Int
    let personDetails: [PersonDetail]
    let activityCode: String
    let shipCode: String
    let activitySlotCode: String
    let startDate: String
    let appointmentLinkId: String
    let isSwapped: Bool
    
    struct PersonDetail: Codable {
        let personId: String
        let reservationNumber: String
        let guestId: String
        let status: String?
    }
}

struct UpdateBookingSlotResponse: Decodable {
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
    func updateBookingSlot(request: UpdateBookingRequestRequestBody) async throws -> UpdateBookingSlotResponse? {
        let request = UpdateBookingSlotRequest(input: request)
        return try await self.requestV2(request, responseModel: UpdateBookingSlotResponse.self)
    }
}

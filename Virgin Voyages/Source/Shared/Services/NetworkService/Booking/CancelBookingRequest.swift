//
//  CancelBookingsRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.11.24.
//

import Foundation

struct CancelBookingRequest: AuthenticatedHTTPRequestProtocol {
    let input: CancelBookingRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.bookActivityVPS
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
    
    var timeoutInterval: TimeInterval {
        120.0
    }
}

struct CancelBookingRequestBody: Codable {
    let appointmentLinkId: String
    let isRefund: Bool
    let operationType: String
    let loggedInReservationGuestId: String
    let reservationNumber: String
    let categoryCode: String
    let personDetails: [PersonDetail]
    
    struct PersonDetail: Codable {
        let personId: String
        let guestId: String
        let reservationNumber: String
        let status: String
    }
    
}


struct CancelBookingResponse: Codable {
    let appointmentLinkId: String?
    let appointmentId: String?
    let paymentStatus: String?
}

extension NetworkServiceProtocol {
    func cancelAppointment(requestModel: CancelBookingRequestBody)  async throws -> CancelBookingResponse? {
        let request = CancelBookingRequest(input: requestModel)
        return try await self.requestV2(request, responseModel: CancelBookingResponse.self)
    }
}

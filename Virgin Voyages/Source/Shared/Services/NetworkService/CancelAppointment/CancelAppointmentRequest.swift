//
//  CancelAppointmentRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.2.25.
//

struct CancelAppointmentRequest: AuthenticatedHTTPRequestProtocol {
    let input: CancelAppointmentRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.cancelAppointment
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

struct CancelAppointmentRequestBody: Codable {
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

struct CancelAppointmentResponse: Decodable {

    let appointmentLinkId: String?
    let paymentStatus: String?
    let message: Error?
    
    struct Error: Decodable {
        let status: Int?
        let title: String?
    }
}

extension NetworkServiceProtocol {
    func cancelAppointment(requestBody: CancelAppointmentRequestBody) async throws -> CancelAppointmentResponse {
        let request = CancelAppointmentRequest(input: requestBody)
        let result = try await self.requestV2(request, responseModel: CancelAppointmentResponse.self)
        return result
    }
}

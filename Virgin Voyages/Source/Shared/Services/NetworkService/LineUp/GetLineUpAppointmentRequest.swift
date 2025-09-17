//
//  GetLineUpAppointmentRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

import Foundation

struct GetLineUpAppointmentRequest: AuthenticatedHTTPRequestProtocol {
    let appointmentId: String

    var path: String {
        return NetworkServiceEndpoint.lineUpAppointmentDetails + "/" + self.appointmentId
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetLineUpAppointmentResponse: Decodable {
    let id: String?
    let imageUrl: String?
    let category: String?
    let pictogramUrl: String?
    let name: String?
    let startDateTime: String?
    let location: String?
    let introduction: String?
    let shortDescription: String?
    let longDescription: String?
    let needToKnows: [String]?
    let editorialBlocks: [String]?
    let inventoryState: String?
    let bookingType: String?
    let selectedSlot: SlotResponse?
	let slots: [SlotResponse]?
    let sailors: [Sailor]?
    let linkId: String?
    let isWithinCancellationWindow: Bool?
	let price: Double?
	let currencyCode: String?
    let isPreVoyageBookingStopped: Bool?
	let externalId: String?
	let categoryCode: String?
    let isEditable: Bool?
    
    struct Sailor: Decodable {
        let guestId: String?
        let reservationGuestId: String?
        let reservationNumber: String?
        let name: String?
        let profileImageUrl: String?
        let isCabinMate: Bool?
    }
}

extension NetworkServiceProtocol {
    func getLineUpAppointmentDetails(appointmentId: String) async throws -> GetLineUpAppointmentResponse? {
        let request = GetLineUpAppointmentRequest(appointmentId: appointmentId)
        let response = try await self.requestV2(request, responseModel: GetLineUpAppointmentResponse.self)
        return response
    }
}

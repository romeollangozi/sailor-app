//
//  GetTreatmentDetailsRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 5.2.25.
//

import Foundation

struct GetTreatmentDetailsRequest: AuthenticatedHTTPRequestProtocol {
    let reservationGuestId: String
    let reservationNumber: String
    let treatmentId: String
    
    var path: String {
        return "/guest-bff/nsa/treatments/\(treatmentId)"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationGuestIdItem = URLQueryItem(name: "reservationGuestId", value: reservationGuestId)
        let reservationNumberItem = URLQueryItem(name: "reservationNumber", value: reservationNumber)
        return [reservationGuestIdItem, reservationNumberItem]
    }
}

struct GetTreatmentDetailsResponse: Decodable {
    struct Option: Decodable {
        struct Slot: Decodable {
            let id: String?
            let startDateTime: String?
            let endDateTime: String?
            let status: String?
            let isBooked: Bool?
			let inventoryCount: Int?
        }
        
        let id: String?
        let duration: String?
        let currencyCode: String?
        let categoryCode: String?
        let price: Double?
        let priceFormatted: String?
        let inventoryState: String?
        let bookingType: String?
		let slots: [SlotResponse]?
        let isPreVoyageBookingStopped: Bool?
        let status: String?
    }
    
    let id: String?
    let name: String?
    let location: String?
    let imageUrl: String?
    let introduction: String?
    let longDescription: String?
    let priceFormatted: String?
    let status: String?
    let isBookingEnabled: Bool?
    let bookButtonText: String?
    let options: [Option]?
	let appointments: AppointmentsResponse?
}

extension NetworkServiceProtocol {
    func getTreatmentDetails(reservationGuestId: String, reservationNumber: String, treatmentId: String) async throws -> GetTreatmentDetailsResponse? {
        let request = GetTreatmentDetailsRequest(reservationGuestId: reservationGuestId, reservationNumber: reservationNumber, treatmentId: treatmentId)
        return try await self.requestV2(request, responseModel: GetTreatmentDetailsResponse.self)
    }
}

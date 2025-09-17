//
//  GetTreatmentAppointmentRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.2.25.
//


import Foundation

struct GetTreatmentAppointmentRequest: AuthenticatedHTTPRequestProtocol {
    let appoitnmentId: String
    
    var path: String {
        return NetworkServiceEndpoint.treatmentsAppointmentDetails + "/" + self.appoitnmentId
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetTreatmentAppointmentResponse: Decodable {
    let id: String?
    let linkId: String?
    let treatmentId: String?
    let treatmentOptionId: String?
    let imageUrl: String?
    let category: String?
    let pictogramUrl: String?
    let name: String?
    let startDateTime: String?
    let location: String?
    let introduction: String?
    let shortDescription: String?
    let longDescription: String?
    let categoryCode: String?
    let currencyCode: String?
    let price: Double?
    let duration: String?
    let inventoryState: String?
    let bookingType: String?
    let isPreVoyageBookingStopped: Bool?
    let isWithinCancellationWindow: Bool?
    let selectedSlot: SlotResponse?
    let slots: [SlotResponse]?
	let sailors: [SailorSimpleResponse]?
    let isEditable: Bool?
}

extension NetworkServiceProtocol {
    func getTreatmentAppointmentDetails(appoitnmentId: String) async throws -> GetTreatmentAppointmentResponse? {
        let request = GetTreatmentAppointmentRequest(appoitnmentId: appoitnmentId)
        return try await self.requestV2(request, responseModel: GetTreatmentAppointmentResponse.self)
    }
}

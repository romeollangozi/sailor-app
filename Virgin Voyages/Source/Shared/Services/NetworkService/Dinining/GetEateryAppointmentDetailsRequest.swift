//
//  GetEateryAppointmentDetails.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import Foundation

struct GetEateryAppointmentDetailsRequest: AuthenticatedHTTPRequestProtocol {
	let appointmentId: String
	
	var path: String {
		return "\(NetworkServiceEndpoint.eateriesAppointments)/\(appointmentId)"
	}
	var method: HTTPMethod {
		return .GET
	}
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct GetEateryAppointmentDetailsResponse: Decodable {
	let id: String?
	let linkId: String?
	let imageUrl: String?
	let category: String?
	let pictogramUrl: String?
	let name: String?
	let startDateTime: String?
	let location: String?
	let needToKnows: [String]?
	let categoryCode: String?
	let inventoryState: String?
	let bookingType: String?
	let isPreVoyageBookingStopped: Bool?
	let isWithinCancellationWindow: Bool?
	let slotId: String?
	let sailors: [SailorSimpleResponse]?
	let externalId: String?
	let venueId: String?
	let mealPeriod: String?
	let isEditable: Bool?
}

extension NetworkServiceProtocol {
	func getEateryAppointmentDetails(appointmentId: String) async throws -> GetEateryAppointmentDetailsResponse? {
		let request = GetEateryAppointmentDetailsRequest(appointmentId: appointmentId)
		
		return try await self.requestV2(request, responseModel: GetEateryAppointmentDetailsResponse.self)
	}
}

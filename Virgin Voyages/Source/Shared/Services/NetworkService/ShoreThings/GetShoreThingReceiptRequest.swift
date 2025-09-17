//
//  GetShoreThingReceiptRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import Foundation

struct GetShoreThingReceiptRequest: AuthenticatedHTTPRequestProtocol {
	let appointmentId: String

	var path: String {
		return NetworkServiceEndpoint.shorexAppointmentDetails + "/" + self.appointmentId
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct GetShoreThingReceiptResponse: Decodable {
	let id: String?
	let externalId: String?
	let linkId: String?
	let imageUrl: String?
	let category: String?
	let pictogramUrl: String?
	let name: String?
	let startDateTime: String?
	let location: String?
	let meetingPlace: String?
	let duration: String?
	let energyLevel: String?
	let types: [String]?
	let reminders: [String]?
	let portCode: String?
	let categoryCode: String?
	let currencyCode: String?
	let price: Double?
	let inventoryState: String?
	let isPreVoyageBookingStopped: Bool?
	let isWithinCancellationWindow: Bool?
	let slots: [SlotResponse]?
	let selectedSlot: SlotResponse?
	let sailors: [SailorSimpleResponse]?
	let isEditable: Bool?
	let waiver: Waiver?
	
	struct Waiver: Decodable {
		let status: String?
		let code: String?
		let version: String?
	}
}

extension NetworkServiceProtocol {
	func getShoreThingReceiptDetails(appointmentId: String) async throws -> GetShoreThingReceiptResponse? {
		let request = GetShoreThingReceiptRequest(appointmentId: appointmentId)
		
		return try await self.requestV2(request, responseModel: GetShoreThingReceiptResponse.self)
	}
}

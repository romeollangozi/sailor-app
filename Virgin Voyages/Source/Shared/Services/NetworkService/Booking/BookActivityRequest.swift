//
//  BookActivityRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/18/24.
//

import Foundation

struct BookActivityRequest: AuthenticatedHTTPRequestProtocol {

	let input: BookActivityRequestBody

	var path: String {
        input.endpointPath
	}

	var method: HTTPMethod {
		.POST
	}

	var headers: (any HTTPHeadersProtocol)? {
        JSONContentTypeHeader()
	}

	var bodyCodable: (any Codable)? {
        input
	}

	var timeoutInterval: TimeInterval {
		120.0
	}
}

struct BookActivityRequestBody: Codable {

	struct PersonDetails: Codable {
		let personId: String
		let reservationNumber: String
		let guestId: String
		let status: String?
	}

	let isPayWithSavedCard: Bool
	let activityCode: String
	let loggedInReservationGuestId: String
	let reservationNumber: String
	let isGift: Bool
	let personDetails: [PersonDetails]
	let activitySlotCode: String
	let accessories: [String]
	let totalAmount: Double
	let currencyCode: String
	let operationType: String?
    let bookableType: String
    let isPreCruise: Bool
	let appointmentLinkId: String?
	let categoryCode: String
	let shipCode: String
	let voyageNumber: String
	let startDate: String
	let endDate: String
    

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(isPayWithSavedCard, forKey: .isPayWithSavedCard)
		try container.encode(activityCode, forKey: .activityCode)
		try container.encode(loggedInReservationGuestId, forKey: .loggedInReservationGuestId)
		try container.encode(reservationNumber, forKey: .reservationNumber)
		try container.encode(isGift, forKey: .isGift)
		try container.encode(personDetails, forKey: .personDetails)
		try container.encode(activitySlotCode, forKey: .activitySlotCode)
		try container.encode(accessories, forKey: .accessories)
		try container.encode(totalAmount, forKey: .totalAmount)
		try container.encode(currencyCode, forKey: .currencyCode)
		try container.encodeIfPresent(operationType, forKey: .operationType)
		try container.encode(categoryCode, forKey: .categoryCode)
		try container.encode(shipCode, forKey: .shipCode)
		try container.encode(voyageNumber, forKey: .voyageNumber)
		try container.encode(startDate, forKey: .startDate)
		try container.encode(endDate, forKey: .endDate)

		if let appointmentLinkId = appointmentLinkId, !appointmentLinkId.isEmpty {
			try container.encode(appointmentLinkId, forKey: .appointmentLinkId)
		}
	}
    
    enum BookActivityRequestBookableType: String, Codable {
        case eatery = "Eatery"
        case shoreExcursion = "ShoreExcursion"
        case treatment = "Treatment"
        case entertainment = "Entertainment"
    }
    
    enum BookActivityRequestBookingOperationType: String {
        case book = ""
        case edit = "EDIT"
        case cancel = "CANCEL"
    }
}

struct TransactionResponse: Codable {
	let appointmentLinkId: String?
	let appointmentId: String?
	let paymentStatus: String?
    let message: String?
    let reason: String?
    let isNoPaymentRequired: Bool?
}

struct GetBookActivityPaymentPageRequest: AuthenticatedHTTPRequestProtocol {

    let input: BookActivityRequestBody

    var path: String {
        input.endpointPath
    }

    var method: HTTPMethod {
        .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        JSONContentTypeHeader()
    }

    var bodyCodable: (any Codable)? {
        input
    }
    
    var timeoutInterval: TimeInterval {
        120.0
    }
}

extension BookActivityRequestBody {
    var endpointPath: String {
        // Local enum value constants
        let eatery = BookActivityRequestBookableType.eatery.rawValue
        let entertainment = BookActivityRequestBookableType.entertainment.rawValue
        let shoreExcursion = BookActivityRequestBookableType.shoreExcursion.rawValue
        let treatment = BookActivityRequestBookableType.treatment.rawValue

        let book = BookActivityRequestBookingOperationType.book.rawValue
        let edit = BookActivityRequestBookingOperationType.edit.rawValue
        let cancel = BookActivityRequestBookingOperationType.cancel.rawValue

        // Local NetworkServiceEndpoint constants
        let vps = NetworkServiceEndpoint.bookActivityVPS
        let vxp = NetworkServiceEndpoint.bookActivityVXP
        let dining = NetworkServiceEndpoint.bookActivityDiningOnly

        switch bookableType {
        case eatery:
            switch operationType {
            case book:
                return dining
            case edit, cancel:
                return vxp
            default:
                break
            }
        case entertainment:
            return vxp

        case shoreExcursion, treatment:
            return isPreCruise ? vps : vxp
        default:
            return isPreCruise ? vps : vxp
        }

        return isPreCruise ? vps : vxp
    }
}


struct GetBookActivityPaymentPageResponse: Codable {
    let paymentToken: String
    let expiresIn: Int
    let links: Links

    enum CodingKeys: String, CodingKey {
        case paymentToken = "payment_token"
        case expiresIn = "expires_in"
        case links = "_links"
    }
}

enum BookActivityResponse: Decodable {
	case transactionResponse(TransactionResponse)
	case getBookActivityPaymentPageResponse(GetBookActivityPaymentPageResponse)
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		if let bookActivityResponse = try? container.decode(GetBookActivityPaymentPageResponse.self) {
			self = .getBookActivityPaymentPageResponse(bookActivityResponse)
			return
		}

		// Try decoding as TransactionResponse first
		if let transactionResponse = try? container.decode(TransactionResponse.self) {
			self = .transactionResponse(transactionResponse)
			return
		}
		
		// If both decoding attempts fail, throw an error
		throw DecodingError.dataCorruptedError(in: container, debugDescription: "Data doesn't match either TransactionResponse or GetBookActivityPaymentPageResponse")
	}
}

extension NetworkServiceProtocol {
    func bookActivity(requestBody: BookActivityRequestBody) async throws -> BookActivityResponse {
        let request = BookActivityRequest(input: requestBody)
        return try await self.requestV2(request, responseModel: BookActivityResponse.self)
    }

	func getBookActivityPaymentPage(requestBody: BookActivityRequestBody) async throws -> BookActivityResponse {
        let request = GetBookActivityPaymentPageRequest(input: requestBody)
        return try await self.requestV2(request, responseModel: BookActivityResponse.self)
    }
}

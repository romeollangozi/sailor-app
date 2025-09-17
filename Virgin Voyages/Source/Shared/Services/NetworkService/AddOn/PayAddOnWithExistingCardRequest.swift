//
//  PayAddOnWithExistingCardRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/25/24.
//

import Foundation

struct PayAddOnWithExistingCardRequest: AuthenticatedHTTPRequestProtocol {

	let reservationNumber: String
	let guestIds: [String]
	let code: String
	let quantity: Int
	let currencyCode: String
	let amount: String
	let guestUniqueId: String

	var path: String {
		return NetworkServiceEndpoint.getAddOnPaymentPagePath
	}

	var method: HTTPMethod {
		return .POST
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	init(reservationNumber: String,
		 guestIds: [String],
		 code: String,
		 quantity: Int,
		 currencyCode: String,
		 amount: String,
		 guestUniqueId: String) {
		self.reservationNumber = reservationNumber
		self.guestIds = guestIds
		self.code = code
		self.quantity = quantity
		self.currencyCode = currencyCode
		self.amount = amount
		self.guestUniqueId = guestUniqueId
	}

	var bodyCodable: (any Codable)? {
		return GetAddOnPaymentPageRequestBody(reservationNumber: reservationNumber,
											  guestIds: guestIds,
											  code: code,
											  quantity: quantity,
											  currencyCode: currencyCode,
											  amount: amount,
											  isSaveCard: true,
											  guestUniqueId: guestUniqueId)
	}
    
    var timeoutInterval: TimeInterval {
        return 90
    }
}

struct PayAddOnWithExistingCardReasonResponse: Codable {
	let response: Response

	struct Response: Codable {
		let reason: Reason

		enum CodingKeys: String, CodingKey {
			case reason
		}

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let reasonString = try container.decodeIfPresent(String.self, forKey: .reason)
			if reasonString == "approved" {
				reason = .approved
			} else {
				reason = .declined
			}
		}
	}

	enum Reason: String, Codable {
		case approved
		case declined
	}
}

enum PayAddOnWithExistingCardResponse {
	case success
	case failure
}

extension PayAddOnWithExistingCardResponse: Decodable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		if let response = try? container.decode(PayAddOnWithExistingCardReasonResponse.self) {
			if response.response.reason == .approved {
				self = .success
			} else {
				self = .failure
			}
		} else if let noPaymentResponse = try? container.decode(NoPaymentRequiredResponse.self) {
			self = .success
		} else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown response format")
		}
	}
}

extension NetworkServiceProtocol {

	func payAddOnWithExistingCard(reservationNumber: String,
								  guestIds: [String],
									code: String,
									quantity: Int,
									currencyCode: String,
									amount: String,
									guestUniqueId: String) async -> PayAddOnWithExistingCardResponse? {
		let payAddOnWithExistingCardRequest = PayAddOnWithExistingCardRequest(reservationNumber: reservationNumber,
																	guestIds: guestIds,
																	code: code,
																	quantity: quantity,
																	currencyCode: currencyCode,
																	amount: amount,
																	guestUniqueId: guestUniqueId)
		let response = await request(payAddOnWithExistingCardRequest, responseModel: PayAddOnWithExistingCardResponse.self)
		return response.response
	}

}


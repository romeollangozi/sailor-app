//
//  GetAddOnPaymentPageRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/23/24.
//

import Foundation

struct GetAddOnPaymentPageRequest: AuthenticatedHTTPRequestProtocol {

    let reservationNumber: String
    let guestIds: [String]
    let code: String
    let quantity: Int
    let currencyCode: String
    let amount: String
    let isSaveCard: Bool
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
         isSaveCard: Bool,
         guestUniqueId: String) {
        self.reservationNumber = reservationNumber
        self.guestIds = guestIds
        self.code = code
        self.quantity = quantity
        self.currencyCode = currencyCode
        self.amount = amount
        self.isSaveCard = isSaveCard
        self.guestUniqueId = guestUniqueId
    }

    var bodyCodable: (any Codable)? {
        return GetAddOnPaymentPageRequestBody(reservationNumber: reservationNumber,
                                              guestIds: guestIds,
                                              code: code,
                                              quantity: quantity,
                                              currencyCode: currencyCode,
                                              amount: amount,
                                              isSaveCard: isSaveCard,
                                              guestUniqueId: guestUniqueId)
    }
}

struct GetAddOnPaymentPageRequestBody: Codable {
    let reservationNumber: String
    let guestIds: [String]
    let code: String
    let quantity: Int
    let currencyCode: String
    let amount: String
    let isSaveCard: Bool
    let guestUniqueId: String
}

struct GetAddOnPaymentPageResponse: Codable {
	let paymentToken: String
	let expiresIn: Int
	let links: Links

	enum CodingKeys: String, CodingKey {
		case paymentToken = "payment_token"
		case expiresIn = "expires_in"
		case links = "_links"
	}
}

struct Links: Codable {
	let form: Link
	let paymentTokenStatus: Link

	enum CodingKeys: String, CodingKey {
		case form
		case paymentTokenStatus = "paymentTokenStatus"
	}
}

struct Link: Codable {
	let href: String
}

enum AddOnPaymentResponse {
	case success(URL)
	case failure
	case noPaymentRequired
}

struct NoPaymentRequiredResponse: Codable {
	let message: String
	let reason: String
	let isNoPaymentRequired: Bool
}

extension AddOnPaymentResponse: Decodable {
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		if let successResponse = try? container.decode(GetAddOnPaymentPageResponse.self) {
			if let url = URL(string: successResponse.links.form.href) {
				self = .success(url)
			} else {
				self = .failure
			}
		} else if let noPaymentResponse = try? container.decode(NoPaymentRequiredResponse.self) {
			self = .noPaymentRequired
		} else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown response format")
		}
	}
}

extension NetworkServiceProtocol {

	func fetchAddOnPaymentPage(reservationNumber: String,
                               guestIds: [String],
                               code: String,
                               quantity: Int,
                               currencyCode: String,
                               amount: String,
                               guestUniqueId: String) async -> AddOnPaymentResponse? {
        let getAddOnPaymentPageRequest = GetAddOnPaymentPageRequest(reservationNumber: reservationNumber,
                                                                    guestIds: guestIds,
                                                                    code: code,
                                                                    quantity: quantity,
                                                                    currencyCode: currencyCode,
                                                                    amount: amount,
                                                                    isSaveCard: false,
                                                                    guestUniqueId: guestUniqueId)
        let response = await request(getAddOnPaymentPageRequest, responseModel: AddOnPaymentResponse.self)
        return response.response
    }
}

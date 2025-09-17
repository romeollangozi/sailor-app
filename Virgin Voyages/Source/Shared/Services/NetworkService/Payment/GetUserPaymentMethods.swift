//
//  GetUserPaymentMethods.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/18/24.
//

struct GetUserPaymentMethodsRequest: AuthenticatedHTTPRequestProtocol {

	var path: String {
		return NetworkServiceEndpoint.getUserPaymentMethods
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct PaymentMethodsResponse: Codable {
	let savedCards: [PaymentMethodsSavedCard]
}

struct PaymentMethodsSavedCard: Codable {
	let cardMaskedNo: String?
	let cardType: String?
	let cardExpiryMonth: String?
	let cardExpiryYear: String?
	let paymentToken: String?
	let name: String?
	let zipcode: String?
}

extension NetworkServiceProtocol {
	func fetchPaymentMethods() async -> PaymentMethodsResponse? {
		let request = GetUserPaymentMethodsRequest()
		let response = await self.request(request, responseModel: PaymentMethodsResponse.self)
		return response.response
	}
}

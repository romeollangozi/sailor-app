//
//  SaveCardRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/1/25.
//


import Foundation

struct SaveCardRequest: AuthenticatedHTTPRequestProtocol {
    var body: SaveCardBody

    var path: String {
        return "/rts-bff/savedcard/add"
    }

    var method: HTTPMethod {
        return .POST
    }

    var headers: HTTPHeadersProtocol? {
        return JSONContentTypeHeader()
    }

    var bodyData: Data? {
        return try? JSONEncoder().encode(body)
    }
}

struct SaveCardBody: Encodable {
    let consumerId: String
    let consumerType: String
    let cardMaskedNo: String
    let cardType: String
    let cardExpiryMonth: String
    let cardExpiryYear: String
    let paymentToken: String
    let zipcode: String
    let billToCity: String
    let billToFirstName: String
    let billToLastName: String
    let billToLine1: String
    let billToLine2: String
    let billToState: String
    let billToZipCode: String
    let shipToCity: String
    let shipToFirstName: String
    let shipToLastName: String
    let shipToLine1: String
    let shipToLine2: String
    let shipToState: String
    let shipToZipCode: String
    let receiptReference: String
    let tokenProvider: String

	init(
		consumerId: String,
		consumerType: String,
		cardMaskedNo: String,
		cardType: String,
		cardExpiryMonth: String,
		cardExpiryYear: String,
		paymentToken: String,
		zipcode: String,
		billToCity: String,
		billToFirstName: String,
		billToLastName: String,
		billToLine1: String,
		billToLine2: String,
		billToState: String,
		billToZipCode: String,
		shipToCity: String,
		shipToFirstName: String,
		shipToLastName: String,
		shipToLine1: String,
		shipToLine2: String,
		shipToState: String,
		shipToZipCode: String,
		receiptReference: String,
		tokenProvider: String
	) {
		self.consumerId = consumerId
		self.consumerType = consumerType
		self.cardMaskedNo = cardMaskedNo
		self.cardType = cardType
		self.cardExpiryMonth = cardExpiryMonth
		self.cardExpiryYear = cardExpiryYear
		self.paymentToken = paymentToken
		self.zipcode = zipcode
		self.billToCity = billToCity
		self.billToFirstName = billToFirstName
		self.billToLastName = billToLastName
		self.billToLine1 = billToLine1
		self.billToLine2 = billToLine2
		self.billToState = billToState
		self.billToZipCode = billToZipCode
		self.shipToCity = shipToCity
		self.shipToFirstName = shipToFirstName
		self.shipToLastName = shipToLastName
		self.shipToLine1 = shipToLine1
		self.shipToLine2 = shipToLine2
		self.shipToState = shipToState
		self.shipToZipCode = shipToZipCode
		self.receiptReference = receiptReference
		self.tokenProvider = tokenProvider
	}
}

struct SaveCardResponse: Decodable {
    let cardMaskedNo: String
    let cardType: String
    let cardExpiryMonth: String
    let cardExpiryYear: String
    let paymentToken: String
    let name: String
    let zipcode: String
    let billToCity: String
    let billToFirstName: String
    let billToLastName: String
    let billToLine1: String
    let billToLine2: String
    let billToState: String
    let billToZipCode: String
    let shipToCity: String
    let shipToFirstName: String
    let shipToLastName: String
    let shipToLine1: String
    let shipToLine2: String
    let shipToState: String
    let shipToZipCode: String
    let receiptReference: String
    let tokenProvider: String
}

extension NetworkServiceProtocol {
    func saveCard(body: SaveCardBody) async throws -> [SaveCardResponse]? {
        let request = SaveCardRequest(body: body)
        return try await self.requestV2(request, responseModel: [SaveCardResponse].self)
    }
}

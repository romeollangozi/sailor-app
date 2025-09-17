//
//  CancelAddonRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.10.24.
//

import Foundation

struct CancelAddonRequest: AuthenticatedHTTPRequestProtocol {

    var code: String
    var reservationNumber: String
    var guestIds: [String]
    var quantity: Int
    
    var path: String {
        return NetworkServiceEndpoint.cancelAddon
    }

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    init(reservationNumber: String, guestIds: [String], code: String, quantity: Int) {
        self.code = code
        self.reservationNumber = reservationNumber
        self.guestIds = guestIds
        self.code = code
        self.quantity = quantity
    }

    var body: [String : Any]? {
        return [
            "reservationNumber": reservationNumber,
            "code": code,
            "guestIds": guestIds,
            "quantity": quantity
        ]
    }
}

extension NetworkServiceProtocol {
    func cancelAddon(reservationNumber: String, guestIds: [String], code: String, quantity: Int) async -> ApiResponse<[CanceledAddonResponse]> {
        let request = CancelAddonRequest(reservationNumber: reservationNumber, guestIds: guestIds, code: code, quantity: quantity)
        return await self.request(request, responseModel: [CanceledAddonResponse].self)
    }
}


struct CanceledAddonResponse: Codable {
    var addons: [CanceledAddonItemResponse?] = []
    let guestRefNumber: String?
}

struct CanceledAddonItemResponse: Codable {
    let code: String?
    let addonCategory: String?
    let type: String?
    let name: String?
    let amount: Double?
    let currencyCode: String?
    let quantity: Int?
    let classifications: [String]?
    let baseAmount: Double?
    let bonusAmount: Double?
    
    init(code: String? = nil, addonCategory: String? = nil, type: String? = nil, name: String? = nil, amount: Double? = nil, currencyCode: String? = nil, quantity: Int? = nil, classifications: [String]? = nil, baseAmount: Double? = nil, bonusAmount: Double? = nil) {
        self.code = code
        self.addonCategory = addonCategory
        self.type = type
        self.name = name
        self.amount = amount
        self.currencyCode = currencyCode
        self.quantity = quantity
        self.classifications = classifications
        self.baseAmount = baseAmount
        self.bonusAmount = bonusAmount
    }
}



struct CanceledAddonModel: Codable {
    let addons: [CanceledAddonItemModel]
    let guestRefNumber: String
    
    static func mapFrom(input: CanceledAddonItemResponse) -> CanceledAddonItemModel {
        return CanceledAddonItemModel(
            code: input.code.value,
            addonCategory: input.addonCategory.value,
            type: input.type.value,
            name: input.name.value,
            amount: input.amount.value,
            currencyCode: input.currencyCode.value,
            quantity: input.quantity.value,
            classifications: input.classifications ?? [],
            baseAmount: input.baseAmount.value,
            bonusAmount: input.bonusAmount.value
        )
    }

    static func mapFrom(input: CanceledAddonResponse) -> CanceledAddonModel {
        let mapItems = input.addons.map { CanceledAddonModel.mapFrom(input: $0 ?? CanceledAddonItemResponse()) }
        return CanceledAddonModel(
            addons: mapItems,
            guestRefNumber: input.guestRefNumber.value
        )
    }
}

struct CanceledAddonItemModel: Codable {
    let code: String
    let addonCategory: String
    let type: String
    let name: String
    let amount: Double
    let currencyCode: String
    let quantity: Int
    let classifications: [String]
    let baseAmount: Double
    let bonusAmount: Double
}

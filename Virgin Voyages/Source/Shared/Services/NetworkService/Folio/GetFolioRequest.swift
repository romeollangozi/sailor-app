//
//  GetFolioRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import Foundation

struct GetFolioRequest: AuthenticatedHTTPRequestProtocol {
	var sailingMode: String
    var reservationGuestId: String
    var reservationId: String

    var path: String {
        return NetworkServiceEndpoint.getFolio
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        return [
			URLQueryItem(name: "reservationGuestId", value: self.reservationGuestId),
			URLQueryItem(name: "reservationId", value: self.reservationId),
			URLQueryItem(name: "sailingMode", value: self.sailingMode)
		]
    }
}

struct GetFolioResponse: Decodable {
    let preCruise: PreCruise?
    let shipboard: Shipboard?

    struct PreCruise: Decodable {
        let imageUrl: String?
        let header: String?
        let subHeader: String?
        let body: String?
    }

    struct Shipboard: Decodable {
        let dependent: Dependent?
        let wallet: Wallet?

        struct Dependent: Decodable {
            let imageUrl: String?
            let name: String?
            let status: String?
            let description: String?
            let instructions: String?
        }

        struct Wallet: Decodable {
            let header: WalletHeader?
            let sailorLoot: SailorLoot?
            let transactions: [Transaction]?

            struct WalletHeader: Decodable {
                let account: AccountInfo?
                let barTabRemaining: BarTabRemaining?
                
                struct AccountInfo: Decodable {
                    let amount: String?
                    let isAmountCredit: Bool?
                    let cardIconUrl: String?
                    let cardNumber: String?
                }

                struct BarTabRemaining: Decodable {
                    let totalAmount: String?
                    let items: [BarTabItem]?

                    struct BarTabItem: Decodable {
                        let name: String?
                        let amount: String?
                        let dependentSailor: TransactionSailor?
                    }
                }
            }

            struct SailorLoot: Decodable {
                let title: String?
                let description: String?
            }

            struct Transaction: Decodable {
                let iconUrl: String?
                let name: String?
                let dateTime: String?
                let itemDescription: String?
                let itemQuantity: Int?
                let type: String?
                let amount: String?
                let subTotal: String?
                let tax: String?
                let total: String?
                let receiptNr: Int?
                let receiptImageUrl: String?
                let dependentSailor: TransactionSailor?
            }

            struct TransactionSailor: Decodable {
                let reservationGuestId: String?
                let name: String?
                let profileImageUrl: String?
            }
        }
    }
}

extension NetworkServiceProtocol {
	func getFolio(sailingMode: String, reservationGuestId: String, reservationId: String) async throws -> GetFolioResponse? {
		let request = GetFolioRequest(
			sailingMode: sailingMode,
			reservationGuestId: reservationGuestId,
			reservationId: reservationId
		)
        return try await self.requestV2(request, responseModel: GetFolioResponse.self)
    }
}

//
//  TransactionDetails.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/19/23.
//

import Foundation

extension Endpoint {
	struct GetTransactionDetails: Requestable {
		typealias RequestType = Request
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/dxpcore/folio/transactiondetails"
		var method: Method = .post
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .shipOnly
		var pathComponent: String?
		var request: RequestType?
		var query: QueryType?
		
		init(reservation: VoyageReservation) {
			request = .init(reservationGuestId: reservation.reservationGuestId)
		}
		
		// MARK: Request Data
		
		struct Request: Encodable {
			var reservationGuestId: String // "fe777d31-5993-4803-896b-07789fac5a74"
		}
		
		// MARK: Response Data
		
		struct Response: Decodable {
			struct Account: Decodable {
				var obcAmount: Double // 0
				var totalCreditAmount: Double? // 1100
				var creditNoExceptions: Double? // 1000
				var creditLimit: Double? // 0
				var unusedNonRefundableCredit: Double? // 100

				var balance: Double? // -660
			}
			
			struct Transaction: Decodable {
				var location: String // "Loot"
				var itemId: Int // 200004870379
				var debitAmount: Double? // 0
				var itemDescription: String // "Bar Tab Sailor Loot $100 (Promotional)"
				var reservationGuestId: String // "fe777d31-5993-4803-896b-07789fac5a74"
				var print: Bool // true

				var currencyCode: String // "USD"
				var department: String // "Accounting"
				var totalAmount: Double // -100
				var created: String // "2023-04-19 16:48"
			}
			
			struct CardDetail: Decodable {
				var cardType: String // "visa"
				var tokenProvider: String // "fexco"
				var cardExpiryYear: String // "27"
				var cardExpiryMonth: String // "05"
				var receiptReference: String // "18dc1bf6-4cfd-4360-88a4-d1d5a55a8448"
				var cardMaskedNo: String // "414709******0522"
			}
			
			var account: Account
			var barTabTransactions: [Transaction]
			var obcTransactions: [Transaction]
			var nonObcTransactions: [Transaction]
		}
	}
}

// MARK: Extension

extension Endpoint.GetTransactionDetails.Response {
	var accountBalance: Double {
		account.balance ?? 0
	}
	
	var barTabCredit: Double? {
		account.unusedNonRefundableCredit
	}
	
	var days: [Date : [Self.Transaction]]? {
		let transactions = (barTabTransactions + nonObcTransactions + obcTransactions).filter {
			$0.totalAmount != 0
		}.sorted {
			$0.date > $1.date
		}
		
		if transactions.count == 0 {
			return nil
		}
		
		return Dictionary(grouping: transactions) {
			$0.date.startOfDay
		}
	}
}

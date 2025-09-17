//
//  ShipWallet.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/12/24.
//

import Foundation

typealias ShipWallet = Endpoint.GetTransactionDetails.Response

// MARK: Extensions

extension ShipWallet.Transaction {
	var date: Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		return dateFormatter.date(from: created) ?? .now
	}
	
	var imageName: String {
		switch department {
			case "Accounting": "dollarsign.circle"
			case "Restaurant": "fork.knife"
			case "Bars": "wineglass"
			case "Tours": "beach.umbrella"
			case "Spa | Salon": "bubbles.and.sparkles"
			case "Box Office": "ticket"
			default: "dollarsign.circle"
		}
	}
}

// MARK: Viewable

struct WalletViewer: Viewable {
	typealias Content = ShipWallet
	var requiresRefresh = true
	var showsTitle = true
	
	func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
		try await authentication.fetch(Endpoint.GetTransactionDetails(reservation: authentication.reservation))
	}
	
	func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
		try authentication.load(Endpoint.GetTransactionDetails(reservation: authentication.reservation))
	}
}

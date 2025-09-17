//
//  AddCreditCardViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/26/24.
//

import WebKit
import SwiftUI
import Foundation

enum AddCreditCardResult: Equatable {
	case success
	case failure(String)
}

@Observable class AddCreditCardViewModel: NSObject, WKScriptMessageHandler, AddCreditCardServiceDelegate {

	private var addCreditCardService: AddCreditCardServiceProtocol

	var url: URL
	var result: AddCreditCardResult?
    var addCreditCardResponse: AddCreditCardResponse?
	var isLoading = false

	var errorText: String {
		if case let .failure(error) = result {
			return error
		} else {
			return ""
		}
	}

	init(url: URL,
		 addCreditCardService: AddCreditCardServiceProtocol = AddCreditCardService()) {
		self.url = url
		self.addCreditCardService = addCreditCardService
		super.init()
		self.addCreditCardService.delegate = self
	}

	func processAddCreditCardResponse(_ response: AddCreditCardResponse) {
        addCreditCardResponse = response
        
		switch response.statusCode {
		case 8200:
			result = .success
		case 299, 803, 804, 805, 806, 810, 811, 815, 816, 817:
			result = .failure("We're having trouble processing your payment, please try again in 5 minutes. If the issue persists, feel free to reach out to Sailor Services for assistance")
		case 801, 807, 808, 809, 813:
			result = .failure("Please check your card details and try again, if the issue persists contact your card provider")
		case 802:
			result = .failure("There are insufficient funds in your account")
		default:
			result = .failure("Looks like we had an issue adding your card. It's not you - it's us. Please try again.")
		}
	}

	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		processMessage(message)
	}

	private func processMessage(_ message: WKScriptMessage) {
		guard message.name == "ios", let messageBody = message.body as? [String: Any] else {
			return
		}

		addCreditCardService.handleAddCreditCardMessage(messageBody)
	}
}

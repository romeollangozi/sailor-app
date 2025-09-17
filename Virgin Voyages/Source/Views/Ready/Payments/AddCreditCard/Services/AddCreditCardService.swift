//
//  AddCreditCardService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/26/24.
//

import WebKit
import Foundation

protocol AddCreditCardServiceProtocol {
	var delegate: AddCreditCardServiceDelegate? { get set }
	func handleAddCreditCardMessage(_ messageBody: [String: Any])
}

protocol AddCreditCardServiceDelegate: AnyObject {
	func processAddCreditCardResponse(_ response: AddCreditCardResponse)
}

class AddCreditCardService: NSObject, AddCreditCardServiceProtocol {

	weak var delegate: AddCreditCardServiceDelegate?

	func handleAddCreditCardMessage(_ messageBody: [String: Any]) {
		guard let responseModel = decodeMessageBody(messageBody) else {
			return
		}

		delegate?.processAddCreditCardResponse(responseModel.toAddCreditCardResponse())
	}

	private func decodeMessageBody(_ messageBody: [String: Any]) -> AddCreditCardResponseDTO? {
		guard let jsonData = try? JSONSerialization.data(withJSONObject: messageBody, options: .prettyPrinted) else {
			return nil
		}

		return try? JSONDecoder().decode(AddCreditCardResponseDTO.self, from: jsonData)
	}
}

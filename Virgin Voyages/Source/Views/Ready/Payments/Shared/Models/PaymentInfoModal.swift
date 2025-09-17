//
//  PaymentInfoModal.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class PaymentInfoModal {
	var okayMessageText: String
	var imageURL: String
	var title: String
	var description: String

	init(okayMessageText: String, imageURL: String, title: String, description: String) {
		self.okayMessageText = okayMessageText
		self.imageURL = imageURL
		self.title = title
		self.description = description
	}
}

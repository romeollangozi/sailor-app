//
//  ExistingCardModal.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class ExistingCardModal {
	var confirmationQuestion: String
	var title: String
	var description: String

	init(confirmationQuestion: String, title: String, description: String) {
		self.confirmationQuestion = confirmationQuestion
		self.title = title
		self.description = description
	}
}

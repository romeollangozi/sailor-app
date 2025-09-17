//
//  ReviewPage.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class ReviewPage {
	var confirmationQuestion: String
	var imageURL: String
	var title: String
	var description: String

	init(confirmationQuestion: String, imageURL: String, title: String, description: String) {
		self.confirmationQuestion = confirmationQuestion
		self.imageURL = imageURL
		self.title = title
		self.description = description
	}
}

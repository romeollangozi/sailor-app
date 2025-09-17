//
//  LoadOfflineModeHomeLandingUseCaseModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//


import Foundation

class LoadOfflineModeHomeLandingUseCaseModel {
	var shipTimeFormattedText: String?
	var allAboardTimeFormattedText: String?
	var lastUpdatedText: String?

	init(
		shipTimeFormattedText: String? = nil,
		allAboardTimeFormattedText: String? = nil,
		lastUpdatedText: String? = nil
	) {
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
		self.lastUpdatedText = lastUpdatedText
	}
}

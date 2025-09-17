//
//  LoadOfflineModeLineUpUseCaseModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/16/25.
//


import Foundation

class LoadOfflineModeLineUpUseCaseModel {
	var shipTimeFormattedText: String?
	var allAboardTimeFormattedText: String?
	var lastUpdatedText: String?
    var shipDateTime: Date?
	var lineUpModel: OfflineModeLineUpModel

	init(
		shipTimeFormattedText: String? = nil,
		allAboardTimeFormattedText: String? = nil,
		lastUpdatedText: String? = nil,
        shipDateTime: Date? = nil,
		lineUpModel: OfflineModeLineUpModel
	) {
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
		self.lastUpdatedText = lastUpdatedText
        self.shipDateTime = shipDateTime
		self.lineUpModel = lineUpModel
	}
}

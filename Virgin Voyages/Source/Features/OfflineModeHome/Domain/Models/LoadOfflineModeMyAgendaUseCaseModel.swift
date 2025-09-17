//
//  LoadOfflineModeMyAgendaUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import Foundation

class LoadOfflineModeMyAgendaUseCaseModel {
	var shipTimeFormattedText: String?
	var allAboardTimeFormattedText: String?
	var lastUpdatedText: String?
	var myAgendaModel: OfflineModeMyAgendaModel

	init(
		shipTimeFormattedText: String? = nil,
		allAboardTimeFormattedText: String? = nil,
		lastUpdatedText: String? = nil,
		myAgendaModel: OfflineModeMyAgendaModel
	) {
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
		self.lastUpdatedText = lastUpdatedText
		self.myAgendaModel = myAgendaModel
	}
}

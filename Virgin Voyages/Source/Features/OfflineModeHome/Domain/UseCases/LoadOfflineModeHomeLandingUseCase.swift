//
//  LoadOfflineModeHomeLandingUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/21/25.
//

import Foundation

protocol LoadOfflineModeHomeLandingUseCaseProtocol {
	func execute() async -> LoadOfflineModeHomeLandingUseCaseModel
}

class LoadOfflineModeHomeLandingUseCase: LoadOfflineModeHomeLandingUseCaseProtocol {

	private var getAllAboardTimeUseCase: GetAllAboardTimeUseCase
	private var getShipTimeUseCase: GetShipTimeUseCase

	init(
		getAllAboardTimeUseCase: GetAllAboardTimeUseCase = GetAllAboardTimeUseCase(),
		getShipTimeUseCase: GetShipTimeUseCase = GetShipTimeUseCase()
	) {
		self.getAllAboardTimeUseCase = getAllAboardTimeUseCase
		self.getShipTimeUseCase = getShipTimeUseCase
	}

	func execute() async -> LoadOfflineModeHomeLandingUseCaseModel {

		var shipTimeFormattedText: String?
		var allAboardTimeFormattedText: String?
		var lastUpdatedText: String?
		if let shipTime = await getShipTimeUseCase.execute() {
			shipTimeFormattedText = shipTime.toHourMinuteDeviceTimeLowercaseMeridiem()

			if let allAboardTime = await getAllAboardTimeUseCase.execute(shipTime: shipTime) {
				allAboardTimeFormattedText = allAboardTime.allAboardTime.toHourMinuteDeviceTimeLowercaseMeridiem()
				lastUpdatedText = "\(formatLastUpdated(date: allAboardTime.lastUpdated))"
			}
		}

		return LoadOfflineModeHomeLandingUseCaseModel(
			shipTimeFormattedText: shipTimeFormattedText,
			allAboardTimeFormattedText: allAboardTimeFormattedText,
			lastUpdatedText: lastUpdatedText
		)
	}

	private func formatLastUpdated(date: Date) -> String {
		let calendar = Calendar.current
		let now = Date()

		let timeString = date.toHourMinuteDeviceTimeLowercaseMeridiem(timeZone: TimeZone.current)

		let isToday = calendar.isDate(date, inSameDayAs: now)

		if isToday {
			return "Last updated \(timeString) Today"
		} else {
			let dateString = date.toUSDateFormat()
			return "Last updated \(timeString) \(dateString)"
		}
	}
}

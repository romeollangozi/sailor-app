//
//  LoadOfflineModeLineUpUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/16/25.
//

import Foundation

protocol LoadOfflineModeLineUpUseCaseProtocol {
	func execute() async -> LoadOfflineModeLineUpUseCaseModel
}

class LoadOfflineModeLineUpUseCase: LoadOfflineModeLineUpUseCaseProtocol {

	private var offlineModeLineUpRepository: OfflineModeLineUpRepositoryProtocol
	private var getAllAboardTimeUseCase: GetAllAboardTimeUseCase
	private var getShipTimeUseCase: GetShipTimeUseCase

	init(
		offlineModeLineUpRepository: OfflineModeLineUpRepositoryProtocol = OfflineModeLineUpRepository(),
		getAllAboardTimeUseCase: GetAllAboardTimeUseCase = GetAllAboardTimeUseCase(),
		getShipTimeUseCase: GetShipTimeUseCase = GetShipTimeUseCase()
	) {
		self.offlineModeLineUpRepository = offlineModeLineUpRepository
		self.getAllAboardTimeUseCase = getAllAboardTimeUseCase
		self.getShipTimeUseCase = getShipTimeUseCase
	}

	func execute() async -> LoadOfflineModeLineUpUseCaseModel {

		var shipTimeFormattedText: String?
		var allAboardTimeFormattedText: String?
		var lastUpdatedText: String?
		let shipTime = await getShipTimeUseCase.execute()
		if let shipTime = shipTime {
			shipTimeFormattedText = shipTime.toHourMinuteDeviceTimeLowercaseMeridiem()
		}
		let shipTimeOrDeviceTime = shipTime ?? Date()

		if let allAboardTime = await getAllAboardTimeUseCase.execute(shipTime: shipTimeOrDeviceTime) {
			allAboardTimeFormattedText = allAboardTime.allAboardTime.toHourMinuteDeviceTimeLowercaseMeridiem()
		}

		let lineUpModel = await offlineModeLineUpRepository.fetchLineUps(date: shipTimeOrDeviceTime)
		lastUpdatedText = "\(formatLastUpdated(date: lineUpModel.lastUpdated))"

		return LoadOfflineModeLineUpUseCaseModel(
			shipTimeFormattedText: shipTimeFormattedText,
			allAboardTimeFormattedText: allAboardTimeFormattedText,
			lastUpdatedText: lastUpdatedText,
            shipDateTime: shipTimeOrDeviceTime,
			lineUpModel: lineUpModel
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

//
//  LoadOfflineModeMyAgendaUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import Foundation

protocol LoadOfflineModeMyAgendaUseCaseProtocol {
	func execute() async -> LoadOfflineModeMyAgendaUseCaseModel
}

class LoadOfflineModeMyAgendaUseCase: LoadOfflineModeMyAgendaUseCaseProtocol {

	private var offlineModeMyAgendaRepository: OfflineModeMyAgendaRepositoryProtocol
	private var getAllAboardTimeUseCase: GetAllAboardTimeUseCase
	private var getShipTimeUseCase: GetShipTimeUseCase

	init(
		offlineModeMyAgendaRepository: OfflineModeMyAgendaRepositoryProtocol = OfflineModeMyAgendaRepository(),
		getAllAboardTimeUseCase: GetAllAboardTimeUseCase = GetAllAboardTimeUseCase(),
		getShipTimeUseCase: GetShipTimeUseCase = GetShipTimeUseCase()
	) {
		self.offlineModeMyAgendaRepository = offlineModeMyAgendaRepository
		self.getAllAboardTimeUseCase = getAllAboardTimeUseCase
		self.getShipTimeUseCase = getShipTimeUseCase
	}

	func execute() async -> LoadOfflineModeMyAgendaUseCaseModel {

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

		let myAgendaModel = await offlineModeMyAgendaRepository.fetchMyAgenda(date: shipTimeOrDeviceTime)
		lastUpdatedText = "\(formatLastUpdated(date: myAgendaModel.lastUpdated))"

		return LoadOfflineModeMyAgendaUseCaseModel(
			shipTimeFormattedText: shipTimeFormattedText,
			allAboardTimeFormattedText: allAboardTimeFormattedText,
			lastUpdatedText: lastUpdatedText,
			myAgendaModel: myAgendaModel
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

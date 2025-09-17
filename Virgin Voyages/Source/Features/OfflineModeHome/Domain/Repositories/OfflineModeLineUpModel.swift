//
//  OfflineModeLineUpModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/16/25.
//


import VVPersist
import Foundation

class OfflineModeLineUpModel {
	var lastUpdated: Date
	var lineUpHours: [OfflineModeLineUpHour]

	init (lastUpdated: Date, lineUpHours: [OfflineModeLineUpHour]) {
		self.lastUpdated = lastUpdated
		self.lineUpHours = lineUpHours
	}
}

class OfflineModeLineUpHour {
	let sequence: Int
	let time: String
	let events: [OfflineModeLineUpEvent]
    let mustSeeEvents: [OfflineModeLineUpEvent]
	let date: Date

	init(sequence: Int, time: String, events: [OfflineModeLineUpEvent], mustSeeEvents: [OfflineModeLineUpEvent], date: Date) {
		self.sequence = sequence
		self.time = time
		self.events = events
        self.mustSeeEvents = mustSeeEvents
		self.date = date
	}
}

class OfflineModeLineUpEvent {
	var name: String
	var location: String
	var timePeriod: String
    var startDateTime: Date

	init(name: String, location: String, timePeriod: String, startDateTime: Date) {
		self.name = name
		self.location = location
		self.timePeriod = timePeriod
        self.startDateTime = startDateTime
	}
}

protocol OfflineModeLineUpRepositoryProtocol {
	func updateLineUps(_ lineUpHours: [OfflineModeLineUpHour]) async
	func fetchLineUps(date: Date) async -> OfflineModeLineUpModel
}

class OfflineModeLineUpRepository: OfflineModeLineUpRepositoryProtocol {

	func updateLineUps(_ lineUpHours: [OfflineModeLineUpHour]) async {
		let session = VVDatabase.shared.createSession()
        let lineUpsDBModel: [LineUpsDBModel] = session.fetchAll()
		if let existingLineUpDBModel = lineUpsDBModel.first {
			existingLineUpDBModel.lastUpdated = Date()
			existingLineUpDBModel.lineUpHours = lineUpHours.compactMap({
				LineUpHourDBModel(
					sequence: $0.sequence,
					time: $0.time,
					date: $0.date,
					lineUps: $0.events.compactMap({
						LineUpEventDBModel(
							name: $0.name,
							location: $0.location,
                            timePeriod: $0.timePeriod,
                            startDateTime: $0.startDateTime
						)
                    }), mustSeeLineUps: $0.mustSeeEvents.compactMap({
                        LineUpEventDBModel(
                            name: $0.name,
                            location: $0.location,
                            timePeriod: $0.timePeriod,
                            startDateTime: $0.startDateTime
                        )
                    })
				)
			})
		} else {
			let newLineUpDBModel = LineUpsDBModel(
				lastUpdated: Date(),
				lineUpHours: lineUpHours.compactMap({
					LineUpHourDBModel(
						sequence: $0.sequence,
						time: $0.time,
						date: $0.date,
						lineUps: $0.events.compactMap({
							LineUpEventDBModel(
								name: $0.name,
								location: $0.location,
								timePeriod: $0.timePeriod,
                                startDateTime: $0.startDateTime
							)
                        }), mustSeeLineUps: $0.mustSeeEvents.compactMap({
                            LineUpEventDBModel(
                                name: $0.name,
                                location: $0.location,
                                timePeriod: $0.timePeriod,
                                startDateTime: $0.startDateTime
                            )
                        })
					)
				})
			)
			session.insert(newLineUpDBModel)
		}

		do {
			try session.save()
		} catch {
			print("Failed to save all aboard times: \(error)")
		}
	}

	func fetchLineUps(date: Date) async -> OfflineModeLineUpModel {
		let session = VVDatabase.shared.createSession()
		let lineUpsDBModel: [LineUpsDBModel] = session.fetchAll()
		if let existingLineUpDBModel = lineUpsDBModel.first {

			// First map/filter lineUpHourDBs
			let filteredLineUpHours: [OfflineModeLineUpHour] = existingLineUpDBModel.lineUpHours.compactMap { lineUpHourDB in
				if let lineUpHourDate = lineUpHourDB.date, isSameDay(date1: lineUpHourDate, date2: date) {
					return OfflineModeLineUpHour(
						sequence: lineUpHourDB.sequence ?? 0,
						time: lineUpHourDB.time,
						events: lineUpHourDB.lineUps.compactMap { eventDB in
							OfflineModeLineUpEvent(
								name: eventDB.name,
								location: eventDB.location,
                                timePeriod: eventDB.timePeriod,
                                startDateTime: eventDB.startDateTime ?? Date()
							)},
                        mustSeeEvents: lineUpHourDB.mustSeeLineUps.compactMap { eventDB in
                            OfflineModeLineUpEvent(
                                name: eventDB.name,
                                location: eventDB.location,
                                timePeriod: eventDB.timePeriod,
                                startDateTime: eventDB.startDateTime ?? Date()
                            )},
						date: lineUpHourDate
					)
				} else {
					return nil
				}
			}

			let sortedLineUpHours = filteredLineUpHours.sorted { $0.sequence < $1.sequence }

			return OfflineModeLineUpModel(
				lastUpdated: existingLineUpDBModel.lastUpdated,
				lineUpHours: sortedLineUpHours
			)
		}

		return OfflineModeLineUpModel(lastUpdated: Date(), lineUpHours: [])
	}
}


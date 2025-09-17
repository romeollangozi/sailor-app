//
//  OfflineModeMyAgendaRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import VVPersist
import Foundation

class OfflineModeMyAgendaModel {
	var lastUpdated: Date
	var bookings: [OfflineModeMyAgendaBooking]

	init (lastUpdated: Date, bookings: [OfflineModeMyAgendaBooking]) {
		self.lastUpdated = lastUpdated
		self.bookings = bookings
	}
}

class OfflineModeMyAgendaBooking {
	var name: String
	var location: String
	var timePeriod: String
	var date: Date

	init(name: String, location: String, timePeriod: String, date: Date) {
		self.name = name
		self.location = location
		self.timePeriod = timePeriod
		self.date = date
	}
}

protocol OfflineModeMyAgendaRepositoryProtocol {
	func updateMyAgendaBookings(_ bookings: [OfflineModeMyAgendaBooking]) async
	func fetchMyAgenda(date: Date) async -> OfflineModeMyAgendaModel
}

class OfflineModeMyAgendaRepository: OfflineModeMyAgendaRepositoryProtocol {

	@MainActor
	func updateMyAgendaBookings(_ bookings: [OfflineModeMyAgendaBooking]) async {
		let session = VVDatabase.shared.createSession()
		let myAgendaDBModel: [MyAgendaDBModel] = session.fetchAll()
		if let existingMyAgendaDBModel = myAgendaDBModel.first {
			existingMyAgendaDBModel.lastUpdated = Date()
			existingMyAgendaDBModel.bookings = bookings.enumerated().compactMap { (index, booking) in MyAgendaBookingDBModel(
					sortIndex: index,
					name: booking.name,
					location: booking.location,
					timePeriod: booking.timePeriod,
					date: booking.date
				)
			}
		} else {
			let myAgendaDBModel = MyAgendaDBModel(
				lastUpdated: Date(),
				bookings: bookings.enumerated().compactMap { (index, booking) in
					MyAgendaBookingDBModel(
						sortIndex: index,
						name: booking.name,
						location: booking.location,
						timePeriod: booking.timePeriod,
						date: booking.date
					)
				})
			session.insert(myAgendaDBModel)
		}

		do {
			try session.save()
		} catch {
			print("Failed to save all aboard times: \(error)")
		}
	}

	@MainActor
	func fetchMyAgenda(date: Date) async -> OfflineModeMyAgendaModel {
		let session = VVDatabase.shared.createSession()
		let myAgendaDBModel: [MyAgendaDBModel] = session.fetchAll()

		if let existingMyAgendaDBModel = myAgendaDBModel.first {
			let sortedBookings = existingMyAgendaDBModel.bookings
				.sorted { ($0.sortIndex ?? 0) < ($1.sortIndex ?? 0) }

			let filteredBookings = sortedBookings.compactMap { booking in
				if let eventDate = booking.date, isSameDay(date1: eventDate, date2: date) {
					return OfflineModeMyAgendaBooking(
						name: booking.name,
						location: booking.location,
						timePeriod: booking.timePeriod,
						date: eventDate
					)
				}
				return nil
			}

			return OfflineModeMyAgendaModel(
				lastUpdated: existingMyAgendaDBModel.lastUpdated,
				bookings: filteredBookings
			)
		}

		return OfflineModeMyAgendaModel(lastUpdated: Date(), bookings: [])
	}
}

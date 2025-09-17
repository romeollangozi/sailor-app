//
//  SyncMyAgendaUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import Foundation

class SyncMyAgendaUseCase {
	private var myVoyageAgendaRepository: MyVoyageAgendaRepositoryProtocol
	private var currentSailorManager: CurrentSailorManagerProtocol
	private var offlineModeMyAgendaRepository: OfflineModeMyAgendaRepositoryProtocol

	init(
		myVoyageAgendaRepository: MyVoyageAgendaRepositoryProtocol = MyVoyageAgendaRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		offlineModeMyAgendaRepository: OfflineModeMyAgendaRepositoryProtocol = OfflineModeMyAgendaRepository()
	) {
		self.myVoyageAgendaRepository = myVoyageAgendaRepository
		self.currentSailorManager = currentSailorManager
		self.offlineModeMyAgendaRepository = offlineModeMyAgendaRepository
	}

	func execute() async throws {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		var portDayAgendaList: [MyVoyageAgenda] = []
		let dayAgenda = try await myVoyageAgendaRepository.fetchMyVoyageAgenda(
			shipCode: currentSailor.shipCode,
			reservationGuestId: currentSailor.reservationGuestId,
			useCache: false)
		portDayAgendaList.append(dayAgenda)

		var bookings: [OfflineModeMyAgendaBooking] = []
		portDayAgendaList.forEach({
			$0.appointments.forEach({
				bookings.append(
					OfflineModeMyAgendaBooking(
						name: $0.name,
						location: $0.location,
						timePeriod: $0.timePeriod,
						date: $0.date
					)
				)
			})
		})

		await offlineModeMyAgendaRepository.updateMyAgendaBookings(bookings)
	}
}

//
//  SyncLineUpUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/16/25.
//


import Foundation

class SyncLineUpUseCase {
	private var lineUpRepository: LineUpRepositoryProtocol
	private var currentSailorManager: CurrentSailorManagerProtocol
	private var offlineModeLineUpRepository: OfflineModeLineUpRepositoryProtocol

	init(
		lineUpRepository: LineUpRepositoryProtocol = LineUpRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		offlineModeLineUpRepository: OfflineModeLineUpRepositoryProtocol = OfflineModeLineUpRepository()
	) {
		self.lineUpRepository = lineUpRepository
		self.currentSailorManager = currentSailorManager
		self.offlineModeLineUpRepository = offlineModeLineUpRepository
	}

	func execute() async throws {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		var lineUpList: [LineUp] = []
		let lineUp = try await lineUpRepository.fetchLineUp(
			reservationGuestId: currentSailor.reservationGuestId,
			startDateTime: nil,
			voyageNumber: currentSailor.voyageNumber,
			reservationNumber: currentSailor.reservationNumber,
			useCache: false
		)
		lineUpList.append(lineUp)
		
        var lineUpHours: [OfflineModeLineUpHour] = []
        lineUpList.forEach({
            $0.events.forEach({ event in
                
                let dayMustSeeEvents: [OfflineModeLineUpEvent] = lineUp.mustSeeEvents
                    .first { Calendar.current.isDate($0.date, inSameDayAs: event.date) }?
                    .items.map {
                        OfflineModeLineUpEvent(
                            name: $0.name,
                            location: $0.location,
                            timePeriod: $0.timePeriod,
                            startDateTime: $0.selectedSlot?.startDateTime ?? Date()
                        )
                    } ?? []
                
                let lineUpHour = OfflineModeLineUpHour(sequence: event.sequence,
                                                       time: event.time,
                                                       events: event.items.compactMap({
                    return OfflineModeLineUpEvent(
                        name: $0.name,
                        location: $0.location,
                        timePeriod: $0.timePeriod,
                        startDateTime: $0.selectedSlot?.startDateTime ?? Date()
                    )
                }),
                                                       mustSeeEvents: dayMustSeeEvents,
                                                       date: event.date)
                
                lineUpHours.append(lineUpHour)
                
            })
        })
		
		await offlineModeLineUpRepository.updateLineUps(lineUpHours)
	}
}

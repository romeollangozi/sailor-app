//
//  LineUpRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.1.25.
//

protocol LineUpRepositoryProtocol {
    func fetchLineUp(
		reservationGuestId: String,
		startDateTime: String?,
		voyageNumber: String,
		reservationNumber: String,
		useCache: Bool
	) async throws -> LineUp
    func fetchLineUpAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> LineUpAppointment?
	func fetchLineUpDetails(eventId: String, slotId: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String, shipCode: String) async throws -> LineUpEvents.EventItem?
}

final class LineUpRepository: LineUpRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func fetchLineUp(
		reservationGuestId: String,
		startDateTime: String? = nil,
		voyageNumber: String,
		reservationNumber: String,
		useCache: Bool = false
	) async throws -> LineUp {

        let response = try await networkService.getLineUp(reservationGuestId: reservationGuestId,
                                                                startDateTime: startDateTime,
                                                                voyageNumber: voyageNumber,
														  reservationNumber: reservationNumber,
														  cacheOption: .timedCache(forceReload: !useCache))
		
        return LineUp(events: LineUpEvents.map(from: response), mustSeeEvents: LineUpEvents.mapMustSeeEvents(from: response), leadTime: response.leadTime?.toDomain())
    }

	func fetchLineUpAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> LineUpAppointment? {
		guard let response = try await networkService.getLineUpAppointmentDetails(appointmentId: appointmentId) else {
			return nil
		}
		return LineUpAppointment.map(from: response, reservationGuestId: reservationGuestId)
	}
	
	func fetchLineUpDetails(eventId: String, slotId: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String, shipCode: String) async throws -> LineUpEvents.EventItem? {
		let response = try await networkService.getLineUpDetails(eventId: eventId,
																 slotId: slotId,
																 reservationGuestId: reservationGuestId,
																 voyageNumber: voyageNumber,
																 reservationNumber: reservationNumber,
																 shipCode: shipCode)

		return response?.toDomain()
	}
}

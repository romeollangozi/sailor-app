//
//  EateriesAppointmentRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

protocol EateriesAppointmentRepositoryProtocol {
	func fetchEateryAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> EateryAppointmentDetails?
}

final class EateriesAppointmentRepository: EateriesAppointmentRepositoryProtocol {
	private let networkService: NetworkServiceProtocol
	
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func fetchEateryAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> EateryAppointmentDetails? {
		guard let response = try await networkService.getEateryAppointmentDetails(appointmentId: appointmentId) else { return nil }
		
		return response.toDomain(reservationGuestId: reservationGuestId)
	}
}

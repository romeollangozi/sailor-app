//
//  GetTreatmentReceiptRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.2.25.
//


protocol GetTreatmentReceiptRepositoryProtocol {
    func fetchTreatmentAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> TreatmentReceipt?
}

class GetTreatmentReceiptRepository: GetTreatmentReceiptRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchTreatmentAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> TreatmentReceipt? {
        guard let response = try await networkService.getTreatmentAppointmentDetails(appoitnmentId: appointmentId) else {
            return nil
        }
		let object = TreatmentReceipt.from(response: response, reservationGuestId: reservationGuestId)
        return TreatmentReceipt.from(response: response, reservationGuestId: reservationGuestId)
    }
}

final class MockTreatmentReceiptRepository: GetTreatmentReceiptRepositoryProtocol {
    var shouldThrowError: Bool = false
    var mockTreatmentReceipt: TreatmentReceipt? = TreatmentReceipt.sample()
    
	func fetchTreatmentAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> TreatmentReceipt? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockTreatmentReceipt
    }
}

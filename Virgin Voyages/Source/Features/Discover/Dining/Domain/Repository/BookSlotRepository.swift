//
//  BookSlotRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

protocol BookSlotRepositoryProtocol {
    func bookSlot(input: BookSlotInput) async throws -> BookSlot?
}

final class BookSlotRepository: BookSlotRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func bookSlot(input: BookSlotInput) async throws -> BookSlot? {
        guard let response = try await networkService.bookSlot(request: input.toRequestBody()) else { return nil }
        
        let appointment = response.message == nil
            ? BookSlot.Appointment(appointmentId: response.appointmentId.value, appointmentLinkId: response.appointmentLinkId.value)
            :nil
        
        let errorMessage = response.message != nil
        ? BookSlot.Error(status: response.message!.status ?? 0, title: ErrorMessageParser.parse(response.message!.title ?? ""))
            : nil
        
        return BookSlot(appointment: appointment, error: errorMessage)
    }
}

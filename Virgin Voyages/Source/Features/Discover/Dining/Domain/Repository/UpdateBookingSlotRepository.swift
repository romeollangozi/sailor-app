//
//  UpdateBookingSlotRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

protocol UpdateBookingSlotRepositoryProtocol {
    func updateBookingSlot(input: UpdateBookingSlotInput) async throws -> UpdateBookingSlot?
}

final class UpdateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func updateBookingSlot(input: UpdateBookingSlotInput) async throws -> UpdateBookingSlot? {
        guard let response = try await networkService.updateBookingSlot(request: input.toRequestBody()) else { return nil }
        
        let appointment = response.message == nil
        ? UpdateBookingSlot.Appointment(appointmentId: response.appointmentId.value, appointmentLinkId: response.appointmentLinkId.value)
        :nil
        
        let errorMessage = response.message != nil
        ? UpdateBookingSlot.Error(status: response.message!.status ?? 0, title: ErrorMessageParser.parse(response.message!.title ?? "An error occured. Please try again."))
        : nil
        
        return UpdateBookingSlot(appointment: appointment, error: errorMessage)
    }
}

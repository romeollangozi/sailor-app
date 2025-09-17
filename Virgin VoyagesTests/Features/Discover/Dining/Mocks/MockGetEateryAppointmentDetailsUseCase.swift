//
//  MockGetEateryAppointmentDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 27.8.25.
//

@testable import Virgin_Voyages

final class MockGetEateryAppointmentDetailsUseCase: GetEateryAppointmentDetailsUseCaseProtocol {
    func execute(appointmentId: String) async throws -> Virgin_Voyages.EateryAppointmentDetails {
        guard let response = mockResponse else { throw VVDomainError.genericError }
        
        return response
    }
    
    var mockResponse: EateryAppointmentDetails?
}

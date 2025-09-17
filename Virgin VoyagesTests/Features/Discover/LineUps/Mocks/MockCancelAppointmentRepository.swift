//
//  MockCancelAppointmentRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/7/25.
//

import Foundation
@testable import Virgin_Voyages

final class MockCancelAppointmentRepository: CancelAppointmentRepositoryProtocol {
    var mockResult: CancelAppointment?
    var shouldThrowError = false
    
    func cancelAppointment(input: CancelAppointmentInput) async throws -> CancelAppointment {
        if shouldThrowError {
            throw NSError(domain: "MockErrorDomain", code: -1, userInfo: nil)
        }
        return mockResult ?? CancelAppointment.empty()
    }
    
    func cancelAppointmentForPreCruise(input: CancelAppointmentInput) async throws -> CancelAppointment {
        if shouldThrowError {
            throw NSError(domain: "MockErrorDomain", code: -1, userInfo: nil)
        }
        return mockResult ?? CancelAppointment.empty()
    }
}

//
//  CancelAppointmentRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.2.25.
//

import Foundation

protocol CancelAppointmentRepositoryProtocol {
    func cancelAppointment(input: CancelAppointmentInput) async throws -> CancelAppointment
    func cancelAppointmentForPreCruise(input: CancelAppointmentInput) async throws -> CancelAppointment
}

final class CancelAppointmentRepository: CancelAppointmentRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func cancelAppointment(input: CancelAppointmentInput) async throws -> CancelAppointment {
        let requestBody = input.toDTO()
        let response = try await networkService.cancelAppointment(requestBody: requestBody)
        return CancelAppointment.map(from: response)
    }

    func cancelAppointmentForPreCruise(input: CancelAppointmentInput) async throws -> CancelAppointment {
        let requestBody = input.toDTO()
        let response = try await networkService.cancelAppointmentFromPreCruise(requestBody: requestBody)
        return CancelAppointment.map(from: response)

    }

    // MARK: - Mock CancelAppointmentRepository
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
}

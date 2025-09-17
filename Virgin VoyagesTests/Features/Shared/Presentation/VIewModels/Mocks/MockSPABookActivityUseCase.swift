//
//  MockSPABookActivityUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 14.8.25.
//

import XCTest
@testable import Virgin_Voyages

// MARK: - Test Spies/Mocks

final class MockSPABookActivityUseCase: BookActivityUseCaseProtocol {
    struct Call {
        let input: BookActivityInputModel?
        let legacyArgs: (activity: BookableActivity, slot: BookableSlot, sailors: [BookableSailorDetails],
                         op: BookingOperationType, bookableType: BookableType, payWithExistingCard: Bool,
                         appointmentId: String?, appointmentLinkId: String?)?
    }

    private(set) var calls: [Call] = []
    var stubbedResult: ActivityBookingServiceResult = .success(.empty())

    // Newer entry point used by the ViewModel
    func execute(input: BookActivityInputModel) async throws -> ActivityBookingServiceResult {
        calls.append(.init(input: input, legacyArgs: nil))
        return stubbedResult
    }

    // Legacy overload (not used by current ViewModel, but required by protocol)
    func execute(
        activity: BookableActivity,
        slot: BookableSlot,
        sailorDetails: [BookableSailorDetails],
        operationType: BookingOperationType,
        bookableType: BookableType,
        payWithExistingCard: Bool,
        appointmentId: String?,
        appointmentLinkId: String?
    ) async throws -> ActivityBookingServiceResult {
        calls.append(.init(
            input: nil,
            legacyArgs: (activity, slot, sailorDetails, operationType, bookableType, payWithExistingCard, appointmentId, appointmentLinkId)
        ))
        return stubbedResult
    }

}


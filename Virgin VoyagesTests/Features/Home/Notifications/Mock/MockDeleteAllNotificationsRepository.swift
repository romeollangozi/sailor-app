//
//  MockDeleteAllNotificationsRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//
import Foundation
@testable import Virgin_Voyages

final class MockDeleteAllNotificationsRepository: DeleteAllNotificationsRepositoryProtocol {
    var response: EmptyResponse?
    var shouldReturnNil: Bool = false
    
    var passedReservationGuestId: String?
    var passedVoyageNumber: String?
    
    func deleteAllNotifications(reservationGuestId: String, voyageNumber: String) async throws -> EmptyResponse? {
        passedReservationGuestId = reservationGuestId
        passedVoyageNumber = voyageNumber
        return shouldReturnNil ? nil : response
    }
}

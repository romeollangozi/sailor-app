//
//  MockHomeNotificationsRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 16.3.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockHomeNotificationsRepository: HomeNotificationsRepositoryProtocol {
    var homeNotification: HomeNotificationsSection?
    var shouldThrowError = false
    
    func fetchHomeNotification(reservationGuestId: String, reservationNumber: String, voyageNumber: String) async throws -> HomeNotificationsSection? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return homeNotification ?? HomeNotificationsSection.empty()
    }
}

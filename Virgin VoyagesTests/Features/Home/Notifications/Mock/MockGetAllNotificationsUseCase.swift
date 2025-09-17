//
//  MockGetAllNotificationsUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockGetAllNotificationsUseCase: GetAllNotificationsUseCaseProtocol {

    var result: Notifications?
    var shouldThrowError: Bool = false
    var thrownError: Error = VVDomainError.genericError
    var receivedPage: Int?

    func execute(page: Int) async throws -> Notifications {
        receivedPage = page

        if shouldThrowError {
            throw thrownError
        }

        guard let result = result else {
            throw VVDomainError.genericError
        }

        return result
    }
}

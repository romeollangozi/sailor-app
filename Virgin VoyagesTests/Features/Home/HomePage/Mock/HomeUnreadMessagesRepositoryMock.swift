//
//  HomeUnreadMessagesRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/1/25.
//

import XCTest
@testable import Virgin_Voyages

final class HomeUnreadMessagesRepositoryMock: HomeUnreadMessagesRepositoryProtocol {

    var shouldThrowError = false
    var mockHomeUnreadMessages: HomeUnreadMessages? = HomeUnreadMessages.sample()
    
    func getHomeUnreadMessages(voyageNumber: String) async throws -> Virgin_Voyages.HomeUnreadMessages? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockHomeUnreadMessages
    }
}

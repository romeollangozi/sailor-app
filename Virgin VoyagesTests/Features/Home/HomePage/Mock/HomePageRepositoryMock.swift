//
//  HomePageRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by TX on 13.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockHomePageRepository: HomePageRepositoryProtocol {

    
    var mockHomePage: HomePage?
    var mockHomeCheckInSection: HomeCheckInSection?

    var shouldThrowError: Bool = false
    var errorToThrow: Error = VVDomainError.genericError

    func fetchHomePageData(reservationNumber: String, reservationGuestId: String, sailingMode: String) async throws -> HomePage? {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockHomePage
    }
    
    func fetchHomePageCheckIn(reservationNumber: String, reservationGuestId: String) async throws -> HomeCheckInSection? {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockHomeCheckInSection
    }
}

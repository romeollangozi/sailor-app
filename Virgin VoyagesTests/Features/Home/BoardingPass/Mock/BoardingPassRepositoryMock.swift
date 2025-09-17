//
//  BoardingPassRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/2/25.
//

import XCTest
@testable import Virgin_Voyages

final class BoardingPassRepositoryMock: BoardingPassRepositoryProtocol {
    
    var shouldThrowError = false
    var mockSailorBoardingPass: SailorBoardingPass? = SailorBoardingPass.sample()
    
    func getBoardingPassContent(reservationNumber: String, reservationGuestId: String, shipCode: String) async throws -> SailorBoardingPass? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockSailorBoardingPass
    }
    
}

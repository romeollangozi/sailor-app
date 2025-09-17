//
//  VoyageActivitiesRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 3/18/25.
//

import XCTest
@testable import Virgin_Voyages

final class VoyageActivitiesRepositoryMock: VoyageActivitiesRepositoryProtocol {
    
    var shouldThrowError = false
    var mockVoyageActivities: VoyageActivitiesSection? = VoyageActivitiesSection.sample()
    
    
    func getVoyageActivitesContent(shipCode: String, reservationId: String, reservationNumber: String, reservationGuestId: String, sailingMode: String) async throws -> VoyageActivitiesSection? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockVoyageActivities
    }
    
}

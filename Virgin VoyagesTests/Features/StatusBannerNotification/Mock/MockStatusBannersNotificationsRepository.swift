//
//  MockStatusBannersNotificationsRepository.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/30/25.
//

import XCTest
@testable import Virgin_Voyages

final class MockStatusBannersNotificationsRepository: StatusBannersNotificationsRepositoryProtocol {
 
    var shouldThrowError = false
    var mockStatusBanners: StatusBannersNotifications? = StatusBannersNotifications.sample()
    
    var passednotificationId: String?
    var passedVoyageNumber: String?
    
    func getStatusBannersNotifications(voyageNumber: String) async throws -> StatusBannersNotifications? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockStatusBanners
    }
    
    func deleteOneNotification(notificationId: String, voyageNumber: String) async throws -> EmptyResponse? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        passednotificationId = notificationId
        passedVoyageNumber = voyageNumber
        return EmptyResponse()
    }
    
}

//
//  GetStatusBannerNotificationsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/30/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetStatusBannerNotificationsUseCaseTests: XCTestCase {
    
    var mockRepository: MockStatusBannersNotificationsRepository!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var useCase: StatusBannersNotificationsUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockStatusBannersNotificationsRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = StatusBannersNotificationsUseCase(statusBannersNotificationsRepository: mockRepository,
                                                    currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        
        let mockStatusBannerNotifications = StatusBannersNotifications.sample()
        mockRepository.mockStatusBanners = mockStatusBannerNotifications
        
        let statusBannersNotifications = try await useCase.execute()
        
        for (index, statusBannersNotificationsItem) in statusBannersNotifications.display.enumerated() {
            
            let mockStatusBannerNotificationsItem = mockStatusBannerNotifications.items[index]
            
            XCTAssertEqual(statusBannersNotificationsItem.id, mockStatusBannerNotificationsItem.id)
            XCTAssertEqual(statusBannersNotificationsItem.title, mockStatusBannerNotificationsItem.title)
            XCTAssertEqual(statusBannersNotificationsItem.description, mockStatusBannerNotificationsItem.description)
            XCTAssertEqual(statusBannersNotificationsItem.type, mockStatusBannerNotificationsItem.type)
            XCTAssertEqual(statusBannersNotificationsItem.data, mockStatusBannerNotificationsItem.data)
        }
        
    }
    
    func testExecute_Error() async {
        
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
    func testExecute_NoData() async {
        
        mockRepository.mockStatusBanners = nil
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }

}



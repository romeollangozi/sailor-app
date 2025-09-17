//
//  SailorDeepLinkNotificationHandlerTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 8/19/25.
//


import XCTest
import UIKit
@testable import Virgin_Voyages

final class SailorDeepLinkNotificationHandlerTests: XCTestCase {
    
    private var mockWebUrlLauncher: MockWebUrlLauncher!
    var sut: SailorDeepLinkNotificationHandler!
    
    override func setUp() {
        super.setUp()
        
        mockWebUrlLauncher = MockWebUrlLauncher()
        sut = SailorDeepLinkNotificationHandler(webUrlLauncher: mockWebUrlLauncher)
    }
    
    override func tearDown() {
        
        mockWebUrlLauncher = nil
        sut = nil
        super.tearDown()
    }
    
    func testSailorDeepLinkNotificationHandler_ValidURL_ShouldOpenURL() {
        // Given
        let type = DeepLinkNotificationType.sailorReviewAsk.rawValue
        let data = "{\"externalUrl\":\"https://application-cert.ship.virginvoyages.com/svc/virginreviewweb/review?id=5ba53723-1cb7-4644-ab40-9024156159b0\"}"
        
        let expectedURL = URL(string: "https://application-cert.ship.virginvoyages.com/svc/virginreviewweb/review?id=5ba53723-1cb7-4644-ab40-9024156159b0")!
        
        // When
        sut.handle(userStatus: UserApplicationStatus.userLoggedInWithReservation,
                   type: type,
                   payload: data)
        
        // Then
        let expectation = XCTestExpectation(description: "URL should be opened")
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.mockWebUrlLauncher.lastOpenedUrl, expectedURL)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSailorDeepLinkNotificationHandler_InvalidURL_ShouldNotOpenURL() {
       // Given
       let type = DeepLinkNotificationType.sailorReviewAsk.rawValue
       let data = "{\"externalUrl\":\"invalid-url\"}"
       
       // When
       sut.handle(userStatus: UserApplicationStatus.userLoggedInWithReservation,
                  type: type,
                  payload: data)
       
       // Then
       let expectation = XCTestExpectation(description: "Invalid URL should not be opened")
        
       DispatchQueue.main.async {
           XCTAssertNil(self.mockWebUrlLauncher.lastOpenedUrl)
           expectation.fulfill()
       }
        
       wait(for: [expectation], timeout: 1.0)
    }
    
}

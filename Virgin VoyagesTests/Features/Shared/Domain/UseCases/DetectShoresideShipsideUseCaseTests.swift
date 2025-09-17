//
//  DetectShoresideShipsideUseCaseTests.swift
//  Virgin Voyages
//
//  Created by TX on 6.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class DetectShoresideShipsideUseCaseTests: XCTestCase {
    
    /// Tests the case where the user transitions from shore to ship.
    /// Expectation: Event is published and location is updated.
    func test_userSwitchesFromShoreToShip_shouldPublishEventAndUpdateLocation() async {
        let mockDetector = MockShipNetworkDetector()
        mockDetector.isReachable = true // Simulates ship network being reachable

        let mockRepo = MockLastKnownSailorConnectionLocationRepository()
        mockRepo.lastSailorLocation = .shore // User was previously on shore

        let mockNotifier = MockUserShoreShipLocationEventsNotificationService()

        let useCase = DetectShoresideShipsideUseCase(
            shipNetworkDetector: mockDetector,
            lastKnownSailorConnectionLocationRepository: mockRepo,
            userShoreShipLocationEventsNotificationService: mockNotifier
        )

        await useCase.execute()

        // User's location should now be .ship
        XCTAssertEqual(mockRepo.lastSailorLocation, .ship)
        // Event should be published
        XCTAssertTrue(mockNotifier.publishedEvents.contains(.userDidSwitchFromShoreToShip))
    }

    /// Tests the case where the user remains on shore.
    /// Expectation: No event is published, location remains the same.
    func test_userRemainsOnShore_shouldNotPublishEvent() async {
        let mockDetector = MockShipNetworkDetector()
        mockDetector.isReachable = false // Simulates user is still on shore

        let mockRepo = MockLastKnownSailorConnectionLocationRepository()
        mockRepo.lastSailorLocation = .shore

        let mockNotifier = MockUserShoreShipLocationEventsNotificationService()

        let useCase = DetectShoresideShipsideUseCase(
            shipNetworkDetector: mockDetector,
            lastKnownSailorConnectionLocationRepository: mockRepo,
            userShoreShipLocationEventsNotificationService: mockNotifier
        )

        await useCase.execute()

        // Location should remain shore
        XCTAssertEqual(mockRepo.lastSailorLocation, .shore)
        // No event should be published
        XCTAssertTrue(mockNotifier.publishedEvents.isEmpty)
    }

    /// Tests the case where the user is already on ship and remains on ship.
    /// Expectation: No event is published, location remains ship.
    func test_userWasAlreadyOnShip_shouldNotPublishEvent() async {
        let mockDetector = MockShipNetworkDetector()
        mockDetector.isReachable = true // Still on ship

        let mockRepo = MockLastKnownSailorConnectionLocationRepository()
        mockRepo.lastSailorLocation = .ship

        let mockNotifier = MockUserShoreShipLocationEventsNotificationService()

        let useCase = DetectShoresideShipsideUseCase(
            shipNetworkDetector: mockDetector,
            lastKnownSailorConnectionLocationRepository: mockRepo,
            userShoreShipLocationEventsNotificationService: mockNotifier
        )

        await useCase.execute()

        // Location should remain ship
        XCTAssertEqual(mockRepo.lastSailorLocation, .ship)
        // No event should be published
        XCTAssertTrue(mockNotifier.publishedEvents.isEmpty)
    }

    /// Tests the case where the repository throws during update.
    /// Expectation: Event is still published, but location is not updated.
    func test_repositoryThrowsError_shouldStillWorkWithoutCrashing() async {
        let mockDetector = MockShipNetworkDetector()
        mockDetector.isReachable = true // Moving to ship

        let mockRepo = MockLastKnownSailorConnectionLocationRepository()
        mockRepo.lastSailorLocation = .shore
        mockRepo.shouldThrowError = true // Simulate failure when updating location

        let mockNotifier = MockUserShoreShipLocationEventsNotificationService()

        let useCase = DetectShoresideShipsideUseCase(
            shipNetworkDetector: mockDetector,
            lastKnownSailorConnectionLocationRepository: mockRepo,
            userShoreShipLocationEventsNotificationService: mockNotifier
        )

        await useCase.execute()

        // Even if update fails, event should still be published
        XCTAssertTrue(mockNotifier.publishedEvents.contains(.userDidSwitchFromShoreToShip))
        // Location should remain unchanged due to error
        XCTAssertEqual(mockRepo.lastSailorLocation, .shore)
    }

}

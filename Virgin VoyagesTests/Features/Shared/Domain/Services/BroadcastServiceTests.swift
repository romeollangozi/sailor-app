//
//  BroadcastServiceTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 9/10/25.
//

import XCTest
import CoreLocation
@testable import Virgin_Voyages

class BroadcastServiceTests: XCTestCase {
    
    var mockBroadcastService: MockBroadcastService!
    
    override func setUp() {
        super.setUp()
        mockBroadcastService = MockBroadcastService()
    }
    
    override func tearDown() {
        mockBroadcastService.reset()
        mockBroadcastService = nil
        super.tearDown()
    }
    
    func testStartBroadcastingSuccess() {
        // Given
        let beaconId = "c55b7f82-3d35-11eb-6439-2242cc110001:44378:21199"
        
        // When
        mockBroadcastService.startBroadcasting(beaconId: beaconId)
        
        // Then
        XCTAssertTrue(mockBroadcastService.startBroadcastingCalled)
        XCTAssertTrue(mockBroadcastService.wasStartBroadcastingCalledExactlyOnce())
        XCTAssertTrue(mockBroadcastService.wasStartBroadcastingCalledWith(beaconId: beaconId))
        XCTAssertEqual(mockBroadcastService.lastBeaconIdCalled, beaconId)
        XCTAssertTrue(mockBroadcastService.isAdvertising)
        XCTAssertNotNil(mockBroadcastService.currentBeaconIdentifier)
    }
    
    func testStopBroadcasting() {
        // Given
        mockBroadcastService.mockIsAdvertising = true
        
        // When
        mockBroadcastService.stopBroadcasting()
        
        // Then
        XCTAssertTrue(mockBroadcastService.stopBroadcastingCalled)
        XCTAssertTrue(mockBroadcastService.wasStopBroadcastingCalledExactlyOnce())
        XCTAssertFalse(mockBroadcastService.isAdvertising)
        XCTAssertNil(mockBroadcastService.currentBeaconIdentifier)
    }
    
    func testStartBroadcastingFailure() {
        // Given
        mockBroadcastService.shouldFailStartBroadcasting = true
        let beaconId = "invalid-beacon-id"
        
        // When
        mockBroadcastService.startBroadcasting(beaconId: beaconId)
        
        // Then
        XCTAssertTrue(mockBroadcastService.startBroadcastingCalled)
        XCTAssertFalse(mockBroadcastService.isAdvertising)
        XCTAssertNil(mockBroadcastService.currentBeaconIdentifier)
    }
    
    func testBluetoothStateChange() {
        // Given
        mockBroadcastService.mockIsAdvertising = true
        
        // When
        mockBroadcastService.simulateBluetoothStateChange(poweredOn: false)
        
        // Then
        XCTAssertFalse(mockBroadcastService.isAdvertising)
        XCTAssertNil(mockBroadcastService.currentBeaconIdentifier)
    }
}

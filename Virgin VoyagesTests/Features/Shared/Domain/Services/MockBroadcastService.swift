//
//  MockBroadcastService.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 9/10/25.
//

import CoreLocation
import Foundation
@testable import Virgin_Voyages

class MockBroadcastService: BroadcastServiceProtocol {
    
    // MARK: - Protocol Properties
    private(set) var isAdvertising: Bool = false
    private(set) var currentBeaconIdentifier: CLBeaconIdentityConstraint?
    
    // MARK: - Mock Tracking Properties
    var startBroadcastingCalled = false
    var stopBroadcastingCalled = false
    var startBroadcastingCallCount = 0
    var stopBroadcastingCallCount = 0
    
    // MARK: - Method Call Tracking
    var capturedBeaconIds: [String] = []
    var lastBeaconIdCalled: String?
    
    // MARK: - Mock Configuration
    var shouldFailStartBroadcasting = false
    var shouldFailParseBeaconId = false
    var simulateBluetoothOff = false
    
    // MARK: - Mock State Control
    var mockIsAdvertising: Bool = false {
        didSet {
            isAdvertising = mockIsAdvertising
        }
    }
    
    // MARK: - Protocol Implementation
    func startBroadcasting() {
        // This method is required by protocol but not used in your current tests
        startBroadcastingCalled = true
        startBroadcastingCallCount += 1
    }
    
    func stopBroadcasting() {
        stopBroadcastingCalled = true
        stopBroadcastingCallCount += 1
        
        mockIsAdvertising = false
        currentBeaconIdentifier = nil
        
        print("Mock: Stopped broadcasting")
    }
    
    // MARK: - Test Method (for your existing tests)
    func startBroadcasting(beaconId: String) {
        startBroadcastingCalled = true
        startBroadcastingCallCount += 1
        capturedBeaconIds.append(beaconId)
        lastBeaconIdCalled = beaconId
        
        // Simulate failure scenarios
        if shouldFailStartBroadcasting {
            print("Mock: Simulating startBroadcasting failure")
            return
        }
        
        if shouldFailParseBeaconId {
            print("Mock: Simulating beacon ID parse failure")
            return
        }
        
        if simulateBluetoothOff {
            print("Mock: Simulating Bluetooth off")
            return
        }
        
        // Simulate successful start
        mockIsAdvertising = true
        
        // Create mock beacon identifier if parsing would succeed
        if let components = MockBroadcastService.parseBeaconId(beaconId),
           let identifier = MockBroadcastService.createBeaconIdentifier(
               uuid: components.uuid,
               major: components.major,
               minor: components.minor
           ) {
            currentBeaconIdentifier = identifier
        }
        
        print("Mock: Successfully started broadcasting beacon: \(beaconId)")
    }
    
    // MARK: - Test Helper Methods
    
    func reset() {
        // Reset call tracking
        startBroadcastingCalled = false
        stopBroadcastingCalled = false
        startBroadcastingCallCount = 0
        stopBroadcastingCallCount = 0
        
        // Reset captured data
        capturedBeaconIds.removeAll()
        lastBeaconIdCalled = nil
        
        // Reset mock configuration
        shouldFailStartBroadcasting = false
        shouldFailParseBeaconId = false
        simulateBluetoothOff = false
        
        // Reset state
        mockIsAdvertising = false
        currentBeaconIdentifier = nil
    }
    
    func simulateBluetoothStateChange(poweredOn: Bool) {
        if !poweredOn && mockIsAdvertising {
            mockIsAdvertising = false
            currentBeaconIdentifier = nil
            print("Mock: Simulating Bluetooth turned off, stopping advertising")
        }
    }
    
    // MARK: - Utility Methods (Mirror the real implementation)
    
    static func parseBeaconId(_ beaconId: String) -> BeaconComponents? {
        let components = beaconId.components(separatedBy: ":")
        
        guard components.count == 3 else { return nil }
        
        let uuidString = components[0]
        
        guard let major = CLBeaconMajorValue(components[1]),
              let minor = CLBeaconMinorValue(components[2]) else {
            return nil
        }
        
        return BeaconComponents(uuid: uuidString, major: major, minor: minor)
    }
    
    static func createBeaconIdentifier(uuid: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) -> CLBeaconIdentityConstraint? {
        guard let proximityUUID = UUID(uuidString: uuid) else {
            return nil
        }
        
        return CLBeaconIdentityConstraint(uuid: proximityUUID, major: major, minor: minor)
    }
}

extension MockBroadcastService {
    
    // Convenience methods for common test scenarios
    func wasStartBroadcastingCalledWith(beaconId: String) -> Bool {
        return capturedBeaconIds.contains(beaconId)
    }
    
    func wasStartBroadcastingCalledExactlyOnce() -> Bool {
        return startBroadcastingCallCount == 1
    }
    
    func wasStopBroadcastingCalledExactlyOnce() -> Bool {
        return stopBroadcastingCallCount == 1
    }
    
    func getCurrentBeaconUUID() -> String? {
        return currentBeaconIdentifier?.uuid.uuidString
    }
    
    func getCurrentBeaconMajor() -> CLBeaconMajorValue? {
        return currentBeaconIdentifier?.major
    }
    
    func getCurrentBeaconMinor() -> CLBeaconMinorValue? {
        return currentBeaconIdentifier?.minor
    }
}

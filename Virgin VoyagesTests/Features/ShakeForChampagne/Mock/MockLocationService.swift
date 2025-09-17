//
//  MockLocationService.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/3/25.
//

import Foundation
import CoreLocation
@testable import Virgin_Voyages

class MockLocationService: LocationServiceProtocol {
    var getLocationAuthorizationStatusCalled = false
    var getLocationAuthorizationStatusCallCount = 0
    
    var requestLocationPermissionsCalled = false
    var requestLocationPermissionsCallCount = 0
    
    // Mock return values
    var mockAuthorizationStatus: LocationAuthorizationStatus = .notDetermined
    var shouldCompletePermissionRequest = true
    
    func getLocationAuthorizationStatus() -> LocationAuthorizationStatus {
        getLocationAuthorizationStatusCalled = true
        getLocationAuthorizationStatusCallCount += 1
        return mockAuthorizationStatus
    }
    
    func requestLocationPermissions() async {
        requestLocationPermissionsCalled = true
        requestLocationPermissionsCallCount += 1
        
        if shouldCompletePermissionRequest {
            // Simulate permission granted after request
            mockAuthorizationStatus = .authorizedWhenInUse
        }
    }
    
    // Helper methods for testing
    func reset() {
        getLocationAuthorizationStatusCalled = false
        getLocationAuthorizationStatusCallCount = 0
        requestLocationPermissionsCalled = false
        requestLocationPermissionsCallCount = 0
        mockAuthorizationStatus = .notDetermined
        shouldCompletePermissionRequest = true
    }
}

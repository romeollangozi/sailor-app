//
//  MockBluetoothService.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/3/25.
//

import Foundation
import CoreBluetooth
@testable import Virgin_Voyages

class MockBluetoothService: BluetoothServiceProtocol {
    
    var checkBluetoothStateCalled = false
    var checkBluetoothStateCallCount = 0
    
    var requestBluetoothPermissionCalled = false
    var requestBluetoothPermissionCallCount = 0
    
    var waitForBluetoothReadyCalled = false
    var waitForBluetoothReadyCallCount = 0
    
    var initializeManagerAndRequestPermissionCalled = false
    var initializeManagerAndRequestPermissionCallCount = 0
    
    // Mock return values
    var mockAuthorizationStatus: CBManagerAuthorization = .notDetermined
    var mockBluetoothState: CBManagerState = .poweredOn
    var shouldCompleteWaitForReady = true
    
    var authorizationStatus: CBManagerAuthorization {
        return mockAuthorizationStatus
    }
    
    func checkBluetoothState() -> CBManagerState {
        checkBluetoothStateCalled = true
        checkBluetoothStateCallCount += 1
        return mockBluetoothState
    }
    
    func requestBluetoothPermission() async -> CBManagerAuthorization {
        requestBluetoothPermissionCalled = true
        requestBluetoothPermissionCallCount += 1
        
        // Simulate permission granted after request
        if mockAuthorizationStatus == .notDetermined {
            mockAuthorizationStatus = .allowedAlways
        }
        
        return mockAuthorizationStatus
    }
    
    func waitForBluetoothReady() async {
        waitForBluetoothReadyCalled = true
        waitForBluetoothReadyCallCount += 1
        
        if shouldCompleteWaitForReady {
            // Simulate bluetooth ready
            return
        }
    }
    
    func initializeManagerAndRequestPermission() async -> CBManagerAuthorization {
        initializeManagerAndRequestPermissionCalled = true
        initializeManagerAndRequestPermissionCallCount += 1
        
        if mockAuthorizationStatus == .notDetermined {
            mockAuthorizationStatus = .allowedAlways
        }
        
        return mockAuthorizationStatus
    }
    
    // Helper methods for testing
    func reset() {
        checkBluetoothStateCalled = false
        checkBluetoothStateCallCount = 0
        requestBluetoothPermissionCalled = false
        requestBluetoothPermissionCallCount = 0
        waitForBluetoothReadyCalled = false
        waitForBluetoothReadyCallCount = 0
        initializeManagerAndRequestPermissionCalled = false
        initializeManagerAndRequestPermissionCallCount = 0
        mockAuthorizationStatus = .notDetermined
        mockBluetoothState = .poweredOn
        shouldCompleteWaitForReady = true
    }
}

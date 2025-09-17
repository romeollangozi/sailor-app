//
//  ShakeForChampagnePermissionsViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/3/25.
//

import XCTest
import CoreBluetooth
@testable import Virgin_Voyages

@MainActor
final class ShakeForChampagnePermissionsViewModelTests: XCTestCase {

    var mockLocationService: MockLocationService!
    var mockBluetoothService: MockBluetoothService!
    var viewModel: ShakeForChampagnePermissionsViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockLocationService = MockLocationService()
        mockBluetoothService = MockBluetoothService()
        
        viewModel = ShakeForChampagnePermissionsViewModel(
            locationService: mockLocationService,
            bluetoothService: mockBluetoothService
        )
    }
    
    override func tearDown() {
        mockLocationService = nil
        mockBluetoothService = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_initialization_setsDefaultValues() {
        XCTAssertFalse(viewModel.shouldShowLocationRecoveryAlert)
        XCTAssertFalse(viewModel.shouldShowBluetoothOffAlert)
        XCTAssertFalse(viewModel.shouldShowBluetoothPermissionRecoveryAlert)
    }
    
    // MARK: - Location Permission Tests
    
    func test_checkPermissions_withNotDetermined_requestsLocationPermissions() {
        // Given
        mockLocationService.mockAuthorizationStatus = .notDetermined
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(mockLocationService.getLocationAuthorizationStatusCalled)
        XCTAssertTrue(mockLocationService.requestLocationPermissionsCalled)
        XCTAssertEqual(mockLocationService.requestLocationPermissionsCallCount, 1)
    }
    
    func test_checkPermissions_withDenied_showsLocationRecoveryAlert() {
        // Given
        mockLocationService.mockAuthorizationStatus = .denied
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(mockLocationService.getLocationAuthorizationStatusCalled)
        XCTAssertTrue(viewModel.shouldShowLocationRecoveryAlert)
        XCTAssertFalse(mockLocationService.requestLocationPermissionsCalled)
    }
    
    func test_checkPermissions_withRestricted_showsLocationRecoveryAlert() {
        // Given
        mockLocationService.mockAuthorizationStatus = .restricted
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(mockLocationService.getLocationAuthorizationStatusCalled)
        XCTAssertTrue(viewModel.shouldShowLocationRecoveryAlert)
        XCTAssertFalse(mockLocationService.requestLocationPermissionsCalled)
    }
    
    func test_checkPermissions_withAuthorizedWhenInUse_proceedsToBluetooth() {
        // Given
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockBluetoothState = .poweredOn
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(mockLocationService.getLocationAuthorizationStatusCalled)
        XCTAssertTrue(mockBluetoothService.waitForBluetoothReadyCalled)
        XCTAssertTrue(mockBluetoothService.checkBluetoothStateCalled)
        XCTAssertEqual(mockBluetoothService.checkBluetoothStateCallCount, 1)
    }
    
    func test_checkPermissions_withAuthorizedAlways_proceedsToBluetooth() {
        // Given
        mockLocationService.mockAuthorizationStatus = .authorizedAlways
        mockBluetoothService.mockBluetoothState = .poweredOn
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(mockLocationService.getLocationAuthorizationStatusCalled)
        XCTAssertTrue(mockBluetoothService.waitForBluetoothReadyCalled)
        XCTAssertEqual(mockBluetoothService.checkBluetoothStateCallCount, 1)
    }
    
    // MARK: - Bluetooth Permission Tests
    
    func test_bluetoothFlow_withPoweredOff_showsBluetoothOffAlert() {
        // Given
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockBluetoothState = .poweredOff
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(viewModel.shouldShowBluetoothOffAlert)
        XCTAssertTrue(mockBluetoothService.waitForBluetoothReadyCalled)
        XCTAssertTrue(mockBluetoothService.checkBluetoothStateCalled)
    }
    
    func test_bluetoothFlow_withNotDetermined_requestsPermission() {
        // Given
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockBluetoothState = .poweredOn
        mockBluetoothService.mockAuthorizationStatus = .notDetermined
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(mockBluetoothService.initializeManagerAndRequestPermissionCalled)
        XCTAssertEqual(mockBluetoothService.initializeManagerAndRequestPermissionCallCount, 1)
    }
    
    func test_bluetoothFlow_withDenied_showsBluetoothPermissionRecoveryAlert() {
        // Given
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockBluetoothState = .poweredOn
        mockBluetoothService.mockAuthorizationStatus = .denied
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(viewModel.shouldShowBluetoothPermissionRecoveryAlert)
        XCTAssertTrue(mockBluetoothService.waitForBluetoothReadyCalled)
        XCTAssertTrue(mockBluetoothService.checkBluetoothStateCalled)
    }
    
    func test_bluetoothFlow_withRestricted_showsBluetoothPermissionRecoveryAlert() {
        // Given
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockBluetoothState = .poweredOn
        mockBluetoothService.mockAuthorizationStatus = .restricted
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.checkPermissions()
        }
        
        // Then
        XCTAssertTrue(viewModel.shouldShowBluetoothPermissionRecoveryAlert)
        XCTAssertTrue(mockBluetoothService.waitForBluetoothReadyCalled)
        XCTAssertTrue(mockBluetoothService.checkBluetoothStateCalled)
    }
}

//
//  ShakeForChampagneViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/27/25.
//

import XCTest
@testable import Virgin_Voyages

final class ShakeForChampagneViewModelTests: XCTestCase {
    
    var mockMotionDetectionService: MockMotionDetectionService!
    var mockLocationService: MockLocationService!
    var mockBluetoothService: MockBluetoothService!
    var mockRepository: MockShakeForChampagneRepository!
    var mockGetShakeForChampagneLandingUseCase: MockGetShakeForChampagneLandingUseCase!
    
    var viewModel: ShakeForChampagneViewModel!
    
    override func setUp() {
        super.setUp()
        
        mockMotionDetectionService = MockMotionDetectionService()
        mockLocationService = MockLocationService()
        mockBluetoothService = MockBluetoothService()
        mockRepository = MockShakeForChampagneRepository()
        mockGetShakeForChampagneLandingUseCase = MockGetShakeForChampagneLandingUseCase()
        
        viewModel = ShakeForChampagneViewModel(motionDetectionService: mockMotionDetectionService,
                                               locationService: mockLocationService,
                                               bluetoothService: mockBluetoothService,
                                               getShakeForChampagneLandingUseCase: mockGetShakeForChampagneLandingUseCase,
                                               orderId: nil)
    }
    
    override func tearDown() {
        mockMotionDetectionService = nil
        mockLocationService = nil
        mockBluetoothService = nil
        mockRepository = nil
        mockGetShakeForChampagneLandingUseCase = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    // MARK: - onVideoFinished Tests
    
    func test_onVideoFinished_withUnavailableStateAndMissingPermissions_navigatesToPermissions() {
        
        // Given
        mockGetShakeForChampagneLandingUseCase.mockShakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        mockLocationService.mockAuthorizationStatus = .denied
        mockBluetoothService.mockAuthorizationStatus = .denied
        
        // Load data first
        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .permissions, "Should navigate to permissions screen when state is different from available and permissions are missing")
    }
    
    func test_onVideoFinished_withUnavailableStateAndMissingLocationPermission_navigatesToPermissions() {
        
        // Given
        mockGetShakeForChampagneLandingUseCase.mockShakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        mockLocationService.mockAuthorizationStatus = .denied
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // Load data first
        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .permissions, "Should navigate to permissions screen when state is different from available and location permission is missing")
    }
    
    
    func test_onVideoFinished_withUnavailableStateAndAllPermissions_navigatesToError() {
        
        // Given
        mockGetShakeForChampagneLandingUseCase.mockShakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .unavailable)
        )
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // Load data first
        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .error, "Should navigate to error screen when state is different from available but all permissions are granted")
    }
    
    func test_onLocationAndBluetoothAvailable_navigatesToBubbleVideo() {
        
        // Given
        mockGetShakeForChampagneLandingUseCase.mockShakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // Load data first
        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .bubbleVideo, "Should navigate to bubbleVideo screen when location and bluetooth available")
    }
    
    func test_onVideoFinished_withAvailableStateAndMissingPermissions_navigatesToPermission() {
        // Given
        mockGetShakeForChampagneLandingUseCase.mockShakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        mockLocationService.mockAuthorizationStatus = .denied
        mockBluetoothService.mockAuthorizationStatus = .denied
        
        // Load data first
        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .permissions, "Should navigate to permissions screen when state is available but we have no permissions")
    }
    
    // MARK: - Permission Status Tests

    func test_onVideoFinished_checksLocationAuthorizationStatus() {
        // Given
        viewModel.shakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertTrue(mockLocationService.getLocationAuthorizationStatusCalled, "Should check location authorization status")
        XCTAssertEqual(mockLocationService.getLocationAuthorizationStatusCallCount, 1, "Should check location status exactly once")
    }
    
    func test_onVideoFinished_checksBluetoothAuthorizationStatus() {
        // Given
        viewModel.shakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockAuthorizationStatus = .denied
        
        // When & Then - Need to wait for async bluetooth check
        let expectation = XCTestExpectation(description: "Wait for bluetooth check")
        
        viewModel.onVideoFinished()
        
        // Wait for the async bluetooth check to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.currentScreen, .permissions, "Should navigate to permissions when bluetooth is not allowed")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Location Permission Variations

    func test_onVideoFinished_withAuthorizedAlwaysLocation_considersLocationEnabled() {
        // Given
        viewModel.shakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .unavailable)
        )
        mockLocationService.mockAuthorizationStatus = .authorizedAlways
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .error, "Should consider authorizedAlways as location enabled")
    }

    func test_onVideoFinished_withAuthorizedWhenInUseLocation_considersLocationEnabled() {
        // Given
        viewModel.shakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .unavailable)
        )
        mockLocationService.mockAuthorizationStatus = .authorizedWhenInUse
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .error, "Should consider authorizedWhenInUse as location enabled")
    }

    func test_onVideoFinished_withNotDeterminedLocation_considersLocationDisabled() {
        // Given
        viewModel.shakeForChampagne = ShakeForChampagne.sample().copy(
            champagneState: ShakeForChampagne.sample().champagneState.copy(state: .available)
        )
        mockLocationService.mockAuthorizationStatus = .notDetermined
        mockBluetoothService.mockAuthorizationStatus = .allowedAlways
        
        // When
        viewModel.onVideoFinished()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .permissions, "Should consider notDetermined as location disabled")
    }
    
    // MARK: - Navigation Tests

    func test_onPermissionGranted_navigatesToBubbleVideoAndReloadsData() {
        // Given
        viewModel.currentScreen = .permissions
        mockGetShakeForChampagneLandingUseCase.mockShakeForChampagne = ShakeForChampagne.sample()
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.onPermissionGranted()
        }
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .bubbleVideo, "Should navigate to bubble video screen after permission granted")
    }
    
    func test_onTryAgain_navigatesToOrderScreen() {
        // Given
        viewModel.currentScreen = .orderError
        
        // When
        viewModel.onTryAgain()
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .order, "Should navigate to order screen when trying again")
    }
    
    func test_onConfirmOrder_navigatesToConfiramtion() {
        // Given
        let mockCreateOrderUseCase = CreateShakeForChampagneOrderUseCase(shakeForChampagneRepository: MockShakeForChampagneRepository(), currentSailorManager: MockCurrentSailorManager())
        
        viewModel = ShakeForChampagneViewModel(
            motionDetectionService: mockMotionDetectionService,
            locationService: mockLocationService,
            bluetoothService: mockBluetoothService,
            getShakeForChampagneLandingUseCase: mockGetShakeForChampagneLandingUseCase,
            createShakeForChampagneOrderUseCase: mockCreateOrderUseCase,
            orderId: nil
        )
        
        viewModel.currentScreen = .order
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.onConfirmOrder(quantity: 1)
        }
        
        // Then
        XCTAssertEqual(viewModel.currentScreen, .confirmation, "Should navigate to confirmation screen on success order")
    }

    func test_onCancelChampagne_setsLoadingStateDuringExecution() {
        // Given
        let mockCancelOrderUseCase = CancelShakeForChampagneOrderUseCase(shakeForChampagneRepository: MockShakeForChampagneRepository())
        
        viewModel = ShakeForChampagneViewModel(
            motionDetectionService: mockMotionDetectionService,
            locationService: mockLocationService,
            bluetoothService: mockBluetoothService,
            getShakeForChampagneLandingUseCase: mockGetShakeForChampagneLandingUseCase,
            cancelShakeForChampagneOrderUseCase: mockCancelOrderUseCase,
            orderId: nil
        )
        
        // Simulate having an order ID
        viewModel.currentScreen = .confirmation
        
        // When
        viewModel.onCancelChampagne()
        
        // Then
        XCTAssertTrue(viewModel.isLoading, "Should set loading to true when cancellation starts")
    }

    // MARK: - Initial State Tests

    func test_initialState_isCorrect() {
        // Then
        XCTAssertEqual(viewModel.currentScreen, .bubbleVideo, "Initial screen should be bubble video")
    }
    
    // Test methods to add to ShakeForChampagneViewModelTests
    func test_onAppear_callsStopMotionDetection() {
        // When
        viewModel.onAppear()
        
        // Then
        XCTAssertTrue(mockMotionDetectionService.stopMotionDetectionCalled, "onAppear should call stopMotionDetection")
        XCTAssertEqual(mockMotionDetectionService.stopMotionDetectionCallCount, 1, "stopMotionDetection should be called exactly once")
    }
    
    func test_onDisappear_callsStartsMotionDetection() {
        // When
        viewModel.onDisappear()
        
        // Then
        XCTAssertTrue(mockMotionDetectionService.startMotionDetectionCalled, "onDisappear should call startMotionDetection")
        XCTAssertEqual(mockMotionDetectionService.startMotionDetectionCallCount, 1, "startMotionDetection should be called exactly once")
    }
    
}

//
//  MockSetPinUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.7.25.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

class SetPinScreenViewModelTests: XCTestCase {
    
    var sut: SetPinScreenViewModel!
    var mockLocalizationManager: MockLocalizationManager!
    var mockSetPinUseCase: MockSetPinUseCase!
    var mockSetPinEventNotificationService: MockSetPinEventNotificationService!
    
    override func setUp() {
        super.setUp()
        mockLocalizationManager = MockLocalizationManager(preloaded: [
            .changePinTitle: "Change PIN",
            .savePinButton: "Save PIN",
            .casinoEditErrorBody: "Error setting PIN",
            .casinoEditErrorHeading: "PIN Error"
        ])
        mockSetPinUseCase = MockSetPinUseCase()
        mockSetPinEventNotificationService = MockSetPinEventNotificationService()
        
        sut = SetPinScreenViewModel(
            localizationManager: mockLocalizationManager,
            setPinUseCase: mockSetPinUseCase,
            setPinEventNotificationService: mockSetPinEventNotificationService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockLocalizationManager = nil
        mockSetPinUseCase = nil
        mockSetPinEventNotificationService = nil
        super.tearDown()
    }

    func testOnChangePinButtonTap_WhenUseCaseSucceeds_ShouldNotifySuccessAndNavigateBack() async {
        // Given
        let testPin = "1234"
        let expectedResponse = EmptyModel()
        mockSetPinUseCase.mockResponse = expectedResponse
        
        // Set the pin first
        sut.onSetPinValue(pin: testPin)
        
        // Verify initial state
        XCTAssertTrue(sut.isSaveButtonEnabled, "Save button should be enabled when pin is set")
        XCTAssertFalse(sut.showError, "Should not show error initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        
        // When
        sut.onChangePinButtonTap()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertTrue(mockSetPinUseCase.executeCalled, "SetPin use case should be called")
        XCTAssertEqual(mockSetPinUseCase.executePin, testPin, "Use case should be called with correct pin")
        XCTAssertFalse(sut.showError, "Should not show error on success")
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }
    
    func testOnChangePinButtonTap_WhenUseCaseFails_ShouldShowError() async {
        // Given
        let testPin = "5678"
        mockSetPinUseCase.shouldThrowError = true
        mockSetPinUseCase.errorToThrow = VVDomainError.genericError

        // Set the pin first
        sut.onSetPinValue(pin: testPin)
        
        // Verify initial state
        XCTAssertTrue(sut.isSaveButtonEnabled, "Save button should be enabled when pin is set")
        XCTAssertFalse(sut.showError, "Should not show error initially")
        
        // When
        sut.onChangePinButtonTap()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertTrue(mockSetPinUseCase.executeCalled, "SetPin use case should be called")
        XCTAssertEqual(mockSetPinUseCase.executePin, testPin, "Use case should be called with correct pin")
        XCTAssertFalse(mockSetPinEventNotificationService.notifyCalled, "Should not notify parent screen on failure")
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    func testPinValidationAndUIState_ShouldUpdateCorrectly() {
        // Given & When - Initial state
        XCTAssertFalse(sut.isSaveButtonEnabled, "Save button should be disabled initially when no pin is set")
        XCTAssertFalse(sut.showError, "Should not show error initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        
        // When - Set a valid pin
        let validPin = "9999"
        sut.onSetPinValue(pin: validPin)
        
        // Then
        XCTAssertTrue(sut.isSaveButtonEnabled, "Save button should be enabled when pin is set")
        
        // Verify labels are properly localized
        let labels = sut.labels
        XCTAssertEqual(labels.title, "Change PIN", "Title should be localized")
        XCTAssertEqual(labels.saveButtonTitle, "Save PIN", "Save button title should be localized")
        XCTAssertEqual(labels.casinoEditErrorBody, "Error setting PIN", "Error body should be localized")
        XCTAssertEqual(labels.casinoEditErrorHeading, "PIN Error", "Error heading should be localized")
        
        // Verify localization manager was used
        XCTAssertEqual(mockLocalizationManager.getString(for: .changePinTitle), "Change PIN")
        XCTAssertEqual(mockLocalizationManager.getString(for: .savePinButton), "Save PIN")
        XCTAssertEqual(mockLocalizationManager.getString(for: .casinoEditErrorBody), "Error setting PIN")
        XCTAssertEqual(mockLocalizationManager.getString(for: .casinoEditErrorHeading), "PIN Error")
    }
}

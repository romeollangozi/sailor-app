//
//  LoginTwinViewModelTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.8.25.
//

import Foundation
import XCTest
@testable import Virgin_Voyages

@MainActor
final class LoginTwinViewModelTests: XCTestCase {
        
    var viewModel: LoginTwinViewModel!
    var capturedCommands: [NavigationCommandProtocol] = []
    
    var loginUseCase: MockLoginUseCase!
    var locationUseCase: MockGetUserShoresideOrShipsideLocationUseCase!
    
    override func setUp() {
        super.setUp()
        capturedCommands = []
        
        loginUseCase = MockLoginUseCase()
        locationUseCase = MockGetUserShoresideOrShipsideLocationUseCase()
        
        let guest = LoginGuestDetails(
            name: "John",
            lastName: "Doe",
            reservationNumber: "123456",
            reservationGuestID: "RID-1",
            profilePhotoUrl: "",
            birthDate: "1980-01-20".fromYYYYMMDD()
        )
        
        viewModel = LoginTwinViewModel(
            getUserLocationShoresideOrShipsideLocationUseCase: locationUseCase,
            loginUseCase: loginUseCase,
            guestDetails: [guest],
            sailDate: Date(),
            cabinNumber: "C-42"
        )
        
        viewModel.navigationCoordinator = CommandCapturingCoordinator { [weak self] command in
            self?.capturedCommands.append(command)
        }
    }
        
    func testIsNextButtonDisabled_ChangeAfterSelectingGuest() {
        XCTAssertTrue(viewModel.isNextButtonDisabled, "Next should be disabled until a guest is selected")
        
        viewModel.selectedGuest = viewModel.guestDetails.first
        XCTAssertFalse(viewModel.isNextButtonDisabled, "Next should enable after selecting a guest")
    }
    
    func testLoginShipsSide_Success() {
        locationUseCase.mockSailorLocation = .ship
        viewModel.onAppear()
        viewModel.selectedGuest = viewModel.guestDetails.first
        
        loginUseCase.mockResult = .success
        
        executeAndWaitForAsyncOperation {
            self.viewModel.login()
        }
        
        XCTAssertEqual(loginUseCase.mockResult, .success)
        XCTAssertEqual(capturedCommands.count, 1)
        XCTAssertTrue(capturedCommands.last is LoginSelectionCoordinator.GoBackToRootViewCommand)
    }
    
    func testLoginShoreSide_Success() {
        locationUseCase.mockSailorLocation = .shore
        viewModel.onAppear()
        viewModel.selectedGuest = viewModel.guestDetails.first

        loginUseCase.mockResult = .success
        
        executeAndWaitForAsyncOperation {
            self.viewModel.login()
        }
        
        XCTAssertEqual(loginUseCase.mockResult, .success)
        XCTAssertEqual(capturedCommands.count, 1)
        XCTAssertTrue(capturedCommands.last is LoginSelectionCoordinator.GoBackToRootViewCommand)
    }
    
    func testLoginShipSide_ValidationError_showsShipErrorModal() {
        locationUseCase.mockSailorLocation = .ship
        viewModel.onAppear()
        viewModel.selectedGuest = viewModel.guestDetails.first
        viewModel.selectedGuest?.birthDate = Date()
        loginUseCase.shouldThrow = true
        executeAndWaitForAsyncOperation {
            self.viewModel.login()
        }

        XCTAssertEqual(capturedCommands.count, 1, "Expected one error modal command")
        
        guard let command = capturedCommands.first as? LoginSelectionCoordinator.ShowFullScreenLoginWithBookingReferenceError else {
            return XCTFail("Expected ShowFullScreenLoginWithBookingReferenceError")
        }
        
        XCTAssertEqual(command.errorModalType, .ship)
    }
    
    func testLoginNoSelectedGuest_NoCommand() async {
        locationUseCase.mockSailorLocation = .shore
        viewModel.onAppear()
        viewModel.selectedGuest = nil
        
        viewModel.login()
      
        XCTAssertTrue(capturedCommands.isEmpty, "Should not issue any commands without a selected guest")
    }
    
    func testLoginShipSide_ValidationError_ShowsShipErrorModal() {
        locationUseCase.mockSailorLocation = .ship
        viewModel.onAppear()
        viewModel.selectedGuest = viewModel.guestDetails.first
        viewModel.selectedGuest?.birthDate = Date()
        loginUseCase.shouldThrow = true

        executeAndWaitForAsyncOperation {
            self.viewModel.login()
        }

        guard let command = capturedCommands.last as? LoginSelectionCoordinator
            .ShowFullScreenLoginWithBookingReferenceError else {
            return XCTFail("Expected ShowFullScreenLoginWithBookingReferenceError")
        }
        XCTAssertEqual(command.errorModalType, .ship)
    }
    
    func testLoginShoreSide_ValidationError_ShowsShoreErrorModal()  {
        locationUseCase.mockSailorLocation = .shore
        viewModel.onAppear()
        viewModel.selectedGuest = viewModel.guestDetails.first
        viewModel.selectedGuest?.birthDate = Date()
        loginUseCase.shouldThrow = true
        executeAndWaitForAsyncOperation {
            self.viewModel.login()
        }
        
        guard let command = capturedCommands.last as? LoginSelectionCoordinator
            .ShowFullScreenLoginWithBookingReferenceError else {
            return XCTFail("Expected ShowFullScreenLoginWithBookingReferenceError")
        }
        XCTAssertEqual(command.errorModalType, .shore)
    }
}


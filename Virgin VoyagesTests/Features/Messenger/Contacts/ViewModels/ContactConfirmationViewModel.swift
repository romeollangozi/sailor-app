//
//  ContactConfirmationViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.11.24.
//

import XCTest
@testable import Virgin_Voyages

class MockConfirmationContactUseCase: ConfirmationContactUseCaseProtocol {
    var confirmationContactModel = ConfirmationContactModel()
    var getViewDataCalled = false
    var qrCodeLink: String?
    
    func getViewData(qrCodeLink: String) -> ConfirmationContactModel {
        getViewDataCalled = true
        self.qrCodeLink = qrCodeLink
        return confirmationContactModel
    }
}

class MockAddContactUseCase: AddContactUseCaseProtocol {
    var expectedResult: Result<EmptyModel, VVDomainError> = .success(EmptyModel())
    var executeCalled = false
    var connectionPersonId: String?
    var isEventVisibleCabinMates: Bool?
    
    func execute(connectionPersonId: String, isEventVisibleCabinMates: Bool) async -> Result<EmptyModel, VVDomainError> {
        executeCalled = true
        self.connectionPersonId = connectionPersonId
        self.isEventVisibleCabinMates = isEventVisibleCabinMates
        return expectedResult
    }
}

final class ContactConfirmationViewModelTests: XCTestCase {
    
    var viewModel: ContactConfirmationViewModel!
    var mockConfirmationContactUseCase: MockConfirmationContactUseCase!
    var mockAddContactUseCase: MockAddContactUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockConfirmationContactUseCase = MockConfirmationContactUseCase()
        mockAddContactUseCase = MockAddContactUseCase()
        
        viewModel = ContactConfirmationViewModel(
            confirmationContactUseCase: mockConfirmationContactUseCase,
            addContactUseCase: mockAddContactUseCase,
            qrCodeInput: "https://example.com?reservationGuestId=testGuestId&reservationId=testReservationId"
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockConfirmationContactUseCase = nil
        mockAddContactUseCase = nil
        super.tearDown()
    }
    
    func testOnAppear_UpdatesConfirmationContactModel() {
        // Act
        viewModel.onAppear()
        
        // Assert
        XCTAssertTrue(mockConfirmationContactUseCase.getViewDataCalled, "Expected getViewData to be called")
        XCTAssertEqual(mockConfirmationContactUseCase.qrCodeLink, viewModel.qrCodeInput, "Expected qrCodeLink to match")
    }
    
    func testAddContactPreferences_CallsExecuteWithCorrectParameters() async {
        // Arrange
        viewModel.allowAttending = true
        mockAddContactUseCase.expectedResult = .success(EmptyModel())
        
        // Act
        await viewModel.addContactPreferences()
        
        // Assert
        XCTAssertTrue(mockAddContactUseCase.executeCalled, "Expected addContactUseCase.execute to be called")
        XCTAssertEqual(mockAddContactUseCase.connectionPersonId, "testGuestId", "Expected connectionPersonId to match")
        XCTAssertEqual(mockAddContactUseCase.isEventVisibleCabinMates, viewModel.allowAttending, "Expected isEventVisibleCabinMates to match allowAttending")
    }
}

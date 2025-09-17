//
//  ContactsScanViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 23.1.25.
//

import XCTest
@testable import Virgin_Voyages
import CoreImage

class MockScanCodeUseCase: ScanCodeUseCaseProtocol {
    var result: Result<ScannerViewModel, Error> = .failure(MockError.test)
    func execute() -> Result<ScannerViewModel, Error> {
        return result
    }
}

class MockReadQRCodeUseCase: ReadQRCodeUseCaseProtocol {
    var result: Result<String, VVDomainError>! = .failure(.genericError)
    func execute(with ciImage: CIImage) -> Result<String, VVDomainError> {
        return result
    }
}

class MockAddFriendUseCase: AddFriendUseCaseProtocol {
    
    var expectedResult = true
    var executeCalled = false
    var connectionReservationId: String?
    var connectionReservationGuestId: String?

    func execute(connectionReservationId: String, connectionReservationGuestId: String) async throws -> Bool {
        executeCalled = true
        self.connectionReservationId = connectionReservationId
        self.connectionReservationGuestId = connectionReservationGuestId
        return expectedResult

    }
}

final class ContactsScanViewModelTests: XCTestCase {

    var viewModel: ContactsScanViewModel!
    var mockScanCodeUseCase: MockScanCodeUseCase!
    var mockReadQRCodeUseCase: MockReadQRCodeUseCase!
    var mockAddFriendUseCase: MockAddFriendUseCase!
    let code = "https://example.com?reservationGuestId=testGuestId&reservationId=testReservationId"

    override func setUp() {
        super.setUp()
        mockScanCodeUseCase = MockScanCodeUseCase()
        mockReadQRCodeUseCase = MockReadQRCodeUseCase()
        mockAddFriendUseCase = MockAddFriendUseCase()

        viewModel = ContactsScanViewModel(
            scanCodeUseCase: mockScanCodeUseCase,
            readQRCodeUseCase: mockReadQRCodeUseCase,
            addFriendUseCase: mockAddFriendUseCase,
			currentSailorManager: MockCurrentSailorManager()
        )
    }

    override func tearDown() {
        viewModel = nil
        mockScanCodeUseCase = nil
        mockReadQRCodeUseCase = nil
        mockAddFriendUseCase = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertNotNil(viewModel.scanCodeModel)
        XCTAssertEqual(viewModel.selectedOption, .scanCode)
        XCTAssertNil(viewModel.scannedCode)
        XCTAssertFalse(viewModel.showHelpMe)
        XCTAssertFalse(viewModel.showConfirmation)
        XCTAssertTrue(viewModel.isScanning)
    }

	func testOnAppearSuccess() async {
        // Arrange
        let expectedModel = ScannerViewModel()
        mockScanCodeUseCase.result = .success(expectedModel)

        // Act
		await viewModel.onAppear()

        // Assert
        XCTAssertEqual(viewModel.scanCodeModel.scanCodeText, expectedModel.scanCodeText, "Expected scan to be success")
    }

	func testOnAppearFailure() async {
        // Arrange
        mockScanCodeUseCase.result = .failure(MockError.test)

        // Act
		await viewModel.onAppear()

        // Assert
        XCTAssertNotNil(viewModel.scanCodeModel)
    }

    func testReadQRCodeFailure() {
        // Arrange
        let ciImage = CIImage()
        mockReadQRCodeUseCase.result = .failure(.genericError)

        // Act
        viewModel.readQRCode(from: ciImage)

        // Assert
        XCTAssertTrue(viewModel.showInvalidQRCodeAlert)
    }

    func testAddFriendFailure() async {
        // Arrange
        mockAddFriendUseCase.expectedResult = false

        // Act
        await viewModel.addFriend(form: code)

        // Assert
        XCTAssertTrue(mockAddFriendUseCase.executeCalled, "Expected addFriendUseCase.execute to be called")
        XCTAssertEqual(mockAddFriendUseCase.expectedResult, false, "Expected addFriendStatus to be failure")
        XCTAssertTrue(viewModel.showInvalidQRCodeAlert)
    }
}

// MARK: - Mocks
enum MockError: Error {
    case test
}

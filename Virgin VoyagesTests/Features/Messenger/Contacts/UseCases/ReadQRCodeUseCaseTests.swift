//
//  ReadQRCodeUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 23.1.25.
//

import XCTest
import CoreImage
@testable import Virgin_Voyages

class MockReadQRCodeService: ReadQRCodeServiceProtocol {
    var resultToReturn: Result<String, VVDomainError>!

    func readQRCode(from ciImage: CIImage) -> Result<String, VVDomainError> {
        return resultToReturn
    }
}

final class ReadQRCodeUseCaseTests: XCTestCase {

    private var mockService: MockReadQRCodeService!
    private var useCase: ReadQRCodeUseCase!

    override func setUp() {
        super.setUp()
        mockService = MockReadQRCodeService()
        useCase = ReadQRCodeUseCase(scannerService: mockService)
    }

    override func tearDown() {
        mockService = nil
        useCase = nil
        super.tearDown()
    }

    func testReadQRCode_Succeeds() {
        // Arrange
        let expectedQRCode = "https://example.com"
        mockService.resultToReturn = .success(expectedQRCode)

        let ciImage = CIImage(image: UIImage(systemName: "qrcode")!)!

        // Act
        let result = useCase.execute(with: ciImage)

        // Assert
        switch result {
        case .success(let qrCodeString):
            XCTAssertEqual(qrCodeString, expectedQRCode, "Expected QR code string does not match.")
        case .failure:
            XCTFail("Expected success but received failure.")
        }
    }

    func testReadQRCode_Fails() {
        // Arrange
        let expectedError = VVDomainError.genericError
        mockService.resultToReturn = .failure(expectedError)

        let ciImage = CIImage(image: UIImage(systemName: "qrcode")!)!

        // Act
        let result = useCase.execute(with: ciImage)

        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure but received success.")
        case .failure(let error):
            XCTAssertEqual(error, expectedError, "Expected error does not match.")
        }
    }
}

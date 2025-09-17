//
//  GetShakeForChampagneLandingUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/17/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetShakeForChampagneLandingUseCaseTests: XCTestCase {
    
    var mockRepository: MockShakeForChampagneRepository!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var useCase: GetShakeForChampagneLandingUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockShakeForChampagneRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetShakeForChampagneLandingUseCase(shakeForChampagneRepository: mockRepository,
                                                     currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        mockCurrentSailorManager = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        
        let mockShakeForChampagneLanding = ShakeForChampagne.sample()
        mockRepository.mockShakeForChampagne = mockShakeForChampagneLanding
        
        let shakeForChampagneLanding = try await useCase.execute()
        
        XCTAssertEqual(shakeForChampagneLanding.title, mockShakeForChampagneLanding.title)
        XCTAssertEqual(shakeForChampagneLanding.description, mockShakeForChampagneLanding.description)
        
        XCTAssertEqual(shakeForChampagneLanding.champagne.name, mockShakeForChampagneLanding.champagne.name)
        XCTAssertEqual(shakeForChampagneLanding.champagne.price, mockShakeForChampagneLanding.champagne.price)
        XCTAssertEqual(shakeForChampagneLanding.champagne.currency, mockShakeForChampagneLanding.champagne.currency)
        XCTAssertEqual(shakeForChampagneLanding.champagne.minQuantity, mockShakeForChampagneLanding.champagne.minQuantity)
        XCTAssertEqual(shakeForChampagneLanding.champagne.maxQuantity, mockShakeForChampagneLanding.champagne.maxQuantity)
        
        XCTAssertEqual(shakeForChampagneLanding.champagneState.state, mockShakeForChampagneLanding.champagneState.state)
        XCTAssertEqual(shakeForChampagneLanding.champagneState.message, mockShakeForChampagneLanding.champagneState.message)
        XCTAssertEqual(shakeForChampagneLanding.champagneState.actionText, mockShakeForChampagneLanding.champagneState.actionText)
        
        XCTAssertEqual(shakeForChampagneLanding.taxExplanationText, mockShakeForChampagneLanding.taxExplanationText)
        XCTAssertEqual(shakeForChampagneLanding.confirmationTitle, mockShakeForChampagneLanding.confirmationTitle)
        XCTAssertEqual(shakeForChampagneLanding.confirmationDescription, mockShakeForChampagneLanding.confirmationDescription)
        XCTAssertEqual(shakeForChampagneLanding.confirmationDeliveryDescription, mockShakeForChampagneLanding.confirmationDeliveryDescription)
        XCTAssertEqual(shakeForChampagneLanding.confirmationHeaderText, mockShakeForChampagneLanding.confirmationHeaderText)
        
        XCTAssertEqual(shakeForChampagneLanding.quote.author, mockShakeForChampagneLanding.quote.author)
        XCTAssertEqual(shakeForChampagneLanding.quote.text, mockShakeForChampagneLanding.quote.text)
        
        XCTAssertEqual(shakeForChampagneLanding.cancellation.title, mockShakeForChampagneLanding.cancellation.title)
        XCTAssertEqual(shakeForChampagneLanding.cancellation.description, mockShakeForChampagneLanding.cancellation.description)
        XCTAssertEqual(shakeForChampagneLanding.cancellation.cancelButton, mockShakeForChampagneLanding.cancellation.cancelButton)
        XCTAssertEqual(shakeForChampagneLanding.cancellation.continueButton, mockShakeForChampagneLanding.cancellation.continueButton)
        XCTAssertEqual(shakeForChampagneLanding.cancellation.successMessage, mockShakeForChampagneLanding.cancellation.successMessage)
        XCTAssertEqual(shakeForChampagneLanding.cancellation.successHeader, mockShakeForChampagneLanding.cancellation.successHeader)
        XCTAssertEqual(shakeForChampagneLanding.cancellation.successActionText, mockShakeForChampagneLanding.cancellation.successActionText)
        
        XCTAssertEqual(shakeForChampagneLanding.cancellationActionText, mockShakeForChampagneLanding.cancellationActionText)
        
        XCTAssertEqual(shakeForChampagneLanding.permission.description, mockShakeForChampagneLanding.permission.description)
    }
    
    func testExecute_Error() async {
        
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
    func testExecute_NoData() async {
        
        mockRepository.mockShakeForChampagne = nil
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
}

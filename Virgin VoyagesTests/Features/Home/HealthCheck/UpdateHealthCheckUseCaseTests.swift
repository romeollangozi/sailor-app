//
//  UpdateHealthCheckUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

import XCTest
@testable import Virgin_Voyages

final class UpdateHealthCheckUseCaseTests: XCTestCase {
    
    private var mockHealthCheckRepository: HomeHealthCheckRepositoryMock!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    private var useCase: UpdateHealthCheckUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockHealthCheckRepository = HomeHealthCheckRepositoryMock()
        mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample())
        useCase = UpdateHealthCheckUseCase(healthCheckRepository: mockHealthCheckRepository,
                                           currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockHealthCheckRepository = nil
        mockCurrentSailorManager = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        
        // Given
        let healthQuestions = [
            UpdateHealthCheckDetailRequestInput.HealthQuestion(questionCode: "Q001", selectedOption: "NO"),
            UpdateHealthCheckDetailRequestInput.HealthQuestion(questionCode: "Q002", selectedOption: "NO"),
            UpdateHealthCheckDetailRequestInput.HealthQuestion(questionCode: "Q003", selectedOption: "NO")
        ]
        
        let signForOtherGuests = ["guest1", "guest2"]
        
        // When
        let result = try await useCase.execute(input: .init(healthQuestions: healthQuestions, signForOtherGuests: signForOtherGuests))
        
        // Then
        let expectedInput = UpdateHealthCheckDetailRequestInput(
            healthQuestions: healthQuestions,
            signForOtherGuests: signForOtherGuests
        )
        
        XCTAssertEqual(expectedInput.healthQuestions.count, mockHealthCheckRepository.updateHealthCheckRequestInput?.healthQuestions.count)
        XCTAssertEqual(expectedInput.signForOtherGuests, mockHealthCheckRepository.updateHealthCheckRequestInput?.signForOtherGuests)
        
        // Verify individual health questions
        for (index, question) in expectedInput.healthQuestions.enumerated() {
            let capturedQuestion = mockHealthCheckRepository.updateHealthCheckRequestInput?.healthQuestions[index]
            XCTAssertEqual(question.questionCode, capturedQuestion?.questionCode)
            XCTAssertEqual(question.selectedOption, capturedQuestion?.selectedOption)
        }
        
        // Verify result properties
        XCTAssertNotNil(result.isHealthCheckComplete)
        XCTAssertNotNil(result.isFitToTravel)
        XCTAssertNotNil(result.healthCheckFailedPage)
    }
    
    func testExecuteSuccessWithEmptyHealthQuestions() async throws {
        // Given
        let healthQuestions: [UpdateHealthCheckDetailRequestInput.HealthQuestion] = []
        let signForOtherGuests = ["guest1"]
        
        // When
        let result = try await useCase.execute(input: .init(healthQuestions: healthQuestions,
                                                            signForOtherGuests: signForOtherGuests))
        
        // Then
        let expectedInput = UpdateHealthCheckDetailRequestInput(
            healthQuestions: healthQuestions,
            signForOtherGuests: signForOtherGuests
        )
        
        XCTAssertEqual(expectedInput.healthQuestions.count, mockHealthCheckRepository.updateHealthCheckRequestInput?.healthQuestions.count)
        XCTAssertEqual(expectedInput.signForOtherGuests, mockHealthCheckRepository.updateHealthCheckRequestInput?.signForOtherGuests)
        XCTAssertTrue(mockHealthCheckRepository.updateHealthCheckRequestInput?.healthQuestions.isEmpty ?? false)
        XCTAssertNotNil(result)
    }
    
    func testExecuteSuccessWithEmptySignForOtherGuests() async throws {
        // Given
        let healthQuestions = [
            UpdateHealthCheckDetailRequestInput.HealthQuestion(questionCode: "Q001", selectedOption: "no")
        ]
        let signForOtherGuests: [String] = []
        
        // When
        let result = try await useCase.execute(input: .init(healthQuestions: healthQuestions,
                                                            signForOtherGuests: signForOtherGuests))
        
        // Then
        let expectedInput = UpdateHealthCheckDetailRequestInput(
            healthQuestions: healthQuestions,
            signForOtherGuests: signForOtherGuests
        )
        
        XCTAssertEqual(expectedInput.healthQuestions.count, mockHealthCheckRepository.updateHealthCheckRequestInput?.healthQuestions.count)
        XCTAssertEqual(expectedInput.signForOtherGuests, mockHealthCheckRepository.updateHealthCheckRequestInput?.signForOtherGuests)
        XCTAssertTrue(mockHealthCheckRepository.updateHealthCheckRequestInput?.signForOtherGuests.isEmpty ?? false)
        XCTAssertNotNil(result)
    }
    
    func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
        // Given
        let healthQuestions = [
            UpdateHealthCheckDetailRequestInput.HealthQuestion(questionCode: "Q001", selectedOption: "no")
        ]
        let signForOtherGuests = ["guest1"]
        mockHealthCheckRepository.shouldThrowError = true
        
        // When/Then
        do {
            _ = try await useCase.execute(input: .init(healthQuestions: healthQuestions,
                                                       signForOtherGuests: signForOtherGuests))
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
}

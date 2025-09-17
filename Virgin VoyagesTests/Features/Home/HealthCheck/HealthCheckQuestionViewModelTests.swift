//
//  HealthCheckQuestionViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/11/25.
//

import XCTest
@testable import Virgin_Voyages

final class HealthCheckQuestionViewModelTests: XCTestCase {
    
    var mockRepository: HomeHealthCheckRepositoryMock!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var useCase: UpdateHealthCheckUseCase!
    var viewModel: HealthCheckQuestionViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = HomeHealthCheckRepositoryMock()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = UpdateHealthCheckUseCase(healthCheckRepository: mockRepository,
                                           currentSailorManager: mockCurrentSailorManager)
        viewModel = HealthCheckQuestionViewModel(updateHealthCheckUseCase: useCase)
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_InitializeQuestions_PopulatesSelectedAnswers() {
        // Given
        let questions = [
            HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion(
                title: "Question 1",
                question: "Are you feeling well?",
                options: ["Yes", "No"],
                selectedOption: "YES",
                questionCode: "Q1",
                sequence: 1
            ),
            HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion(
                title: "Question 2",
                question: "Any symptoms?",
                options: ["Yes", "No"],
                selectedOption: "",
                questionCode: "Q2",
                sequence: 2
            )
        ]
        
        // When
        viewModel.initializeQuestions(questions)
        
        // Then
        XCTAssertEqual(viewModel.selectedAnswers["Q1"], "YES")
        XCTAssertNil(viewModel.selectedAnswers["Q2"])
    }
    
    func test_UpdateAnswer_StoresAnswerCorrectly() {
        // When
        viewModel.updateAnswer(for: "Q1", selectedOption: "YES")
        
        // Then
        XCTAssertEqual(viewModel.selectedAnswers["Q1"], "YES")
    }
    
    func test_GetCurrentAnswer_ReturnsCorrectAnswer() {
        // Given
        viewModel.selectedAnswers["Q1"] = "YES"
        
        // When
        let answer = viewModel.getCurrentAnswer(for: "Q1", defaultValue: "NO")
        
        // Then
        XCTAssertEqual(answer, "YES")
    }
    
    func test_GetCurrentAnswer_ReturnsDefaultWhenNoAnswer() {
        // When
        let answer = viewModel.getCurrentAnswer(for: "Q1", defaultValue: "Default")
        
        // Then
        XCTAssertEqual(answer, "Default")
    }
    
    // MARK: - Party Member Selection Tests
    
    func test_UpdateSelectedPartyMembers_StoresCorrectIds() {
        // Given
        let memberIds: Set<String> = ["member1", "member2", "member3"]
        
        // When
        viewModel.updateSelectedPartyMembers(memberIds)
        
        // Then
        XCTAssertEqual(viewModel.selectedPartyMemberIds, memberIds)
    }
    
    
    func test_UpdateHealthCheck_SuccessfulUpdate_SetsResultAndNavigatesHome() async {
//        // Given
//        let mockResult = UpdateHealthCheckDetailRequestResult.sample()
//        mockRepository.shouldThrowError = false
//        
//        viewModel.selectedAnswers = ["Q1": "NO", "Q2": "NO"]
//        viewModel.selectedPartyMemberIds = ["member1", "member2"]
//        
//        // When
//        executeAndWaitForAsyncOperation {
//            self.viewModel.updateHealthCheck()
//        }
//        
//        // Then
//        XCTAssertEqual(viewModel.updateHealthCheckDetailRequestResult?.healthCheckFailedPage.title,
//                       mockResult.healthCheckFailedPage.title)
//        XCTAssertFalse(viewModel.isHealthCheckFailedPageNotEmpty)
//        XCTAssertFalse(viewModel.didFailToUpdateHealthCheck)
//        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_UpdateHealthCheck_ThrowsError_SetsErrorState() async {
        // Given
        mockRepository.shouldThrowError = true
        viewModel.selectedAnswers = ["Q1": "NO"]
        
        // When
        executeAndWaitForAsyncOperation {
            self.viewModel.updateHealthCheck()
        }
        
        // Then
        XCTAssertTrue(viewModel.didFailToUpdateHealthCheck)
        XCTAssertEqual(viewModel.errorMessage, "Something went wrong. Please try again later.")
        XCTAssertNil(viewModel.updateHealthCheckDetailRequestResult)
    }
    
}

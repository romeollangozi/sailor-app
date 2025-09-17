//
//  HealthCheckQuestionViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/5/25.
//

import SwiftUI

@Observable class HealthCheckQuestionViewModel: BaseViewModel, HealthCheckQuestionViewModelProtocol {
    
    private let updateHealthCheckUseCase: UpdateHealthCheckUseCaseProtocol
    
    var updateHealthCheckDetailRequestResult: UpdateHealthCheckDetailRequestResult?
    
    var isHealthCheckFailedPageNotEmpty: Bool = false
    var didFailToUpdateHealthCheck: Bool = false
    var errorMessage: String?
    
    var didTapCancel: Bool = false
    
    var selectedAnswers: [String: String] = [:]
    private var healthQuestions: [HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion] = []
    var selectedPartyMemberIds: Set<String> = []
    
    init(updateHealthCheckUseCase: UpdateHealthCheckUseCaseProtocol = UpdateHealthCheckUseCase()) {
        self.updateHealthCheckUseCase = updateHealthCheckUseCase
    }
    
    func onBackButtonTapped() {
        executeNavigationCommand(HealthCheckCoordinator.NavigateBackCommand())
    }
    
    func goToHomeScreen() {
        executeNavigationCommand(HomeDashboardCoordinator.DismissFullScreenCoverCommand(pathToDismiss: .healthCheckLanding))
    }
    
    func initializeQuestions(_ questions: [HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion]) {
        self.healthQuestions = questions
        // Pre-populate with existing selections
        for question in questions {
            if !question.selectedOption.isEmpty {
                selectedAnswers[question.questionCode] = question.selectedOption
            }
        }
    }
    
    func updateAnswer(for questionCode: String, selectedOption: String) {
        selectedAnswers[questionCode] = selectedOption
    }
    
    func getCurrentAnswer(for questionCode: String, defaultValue: String = "") -> String {
        return selectedAnswers[questionCode] ?? defaultValue
    }
    
    private func createHealthQuestions() -> [UpdateHealthCheckDetailRequestInput.HealthQuestion] {
        return selectedAnswers.compactMap { (questionCode, selectedOption) in
            guard !selectedOption.isEmpty else { return nil }
            return UpdateHealthCheckDetailRequestInput.HealthQuestion(questionCode: questionCode, selectedOption: selectedOption.uppercased())
        }
    }
    
    func updateSelectedPartyMembers(_ memberIds: Set<String>) {
        selectedPartyMemberIds = memberIds
    }
    
    func areAllQuestionsAnswered() -> Bool {
        return healthQuestions.allSatisfy { question in
            selectedAnswers[question.questionCode]?.isEmpty == false || !question.selectedOption.isEmpty
        }
    }

    func updateHealthCheck() {
        
        let healthQuestions = createHealthQuestions()
        let requestInput = UpdateHealthCheckDetailRequestInput(
            healthQuestions: healthQuestions,
            signForOtherGuests: Array(selectedPartyMemberIds)
        )
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                let result = try await UseCaseExecutor.execute {
                    try await self.updateHealthCheckUseCase.execute(input: requestInput)
                }
                
                await executeOnMain {
                    self.updateHealthCheckDetailRequestResult = result
                    self.isHealthCheckFailedPageNotEmpty = !result.healthCheckFailedPage.title.isEmpty && !result.healthCheckFailedPage.description.isEmpty && !result.healthCheckFailedPage.imageURL.isEmpty
                    
                    if !self.isHealthCheckFailedPageNotEmpty {
                        self.goToHomeScreen()
                    }
                }
            } catch {
                
                self.didFailToUpdateHealthCheck = true
                self.errorMessage = "Something went wrong. Please try again later."
                
            }
        }
    }
    
}


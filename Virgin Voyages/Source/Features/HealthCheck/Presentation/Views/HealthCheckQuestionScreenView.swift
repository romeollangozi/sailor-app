//
//  HealthCheckQuestionScreenView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/5/25.
//

import SwiftUI
import VVUIKit

protocol HealthCheckQuestionViewModelProtocol {
    
    var updateHealthCheckDetailRequestResult: UpdateHealthCheckDetailRequestResult? { get }
    
    var isHealthCheckFailedPageNotEmpty: Bool { get set }
    var didFailToUpdateHealthCheck: Bool { get set }
    var errorMessage: String? { get set }
    var didTapCancel: Bool { get set }
    
    func onBackButtonTapped()
    func goToHomeScreen()
    
    func initializeQuestions(_ questions: [HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion])
    func updateAnswer(for questionCode: String, selectedOption: String)
    func getCurrentAnswer(for questionCode: String, defaultValue: String) -> String
    func areAllQuestionsAnswered() -> Bool
    
    func updateSelectedPartyMembers(_ memberIds: Set<String>)
    
    func updateHealthCheck()
}

struct HealthCheckQuestionScreenView: View {
    
    @State var viewModel: HealthCheckQuestionViewModelProtocol
    
    let healthCheckDetail: HealthCheckDetail
    
    init(viewModel: HealthCheckQuestionViewModelProtocol = HealthCheckQuestionViewModel(),
         healthCheckDetail: HealthCheckDetail) {
        
        _viewModel = State(wrappedValue: viewModel)
        self.healthCheckDetail = healthCheckDetail
        
        viewModel.initializeQuestions(healthCheckDetail.landingPage.questionsPage.healthQuestions)
    }
    
    var body: some View {
        VVUIKit.ContentView {
            VStack {
                backButton()
                
                ForEach(healthCheckDetail.landingPage.questionsPage.healthQuestions.sortedBySequence()) { question in
                    
                    HealthCheckQuestionItemView(
                        healthCheckQuestion: question,
                        selectedOption: Binding(
                            get: { viewModel.getCurrentAnswer(for: question.questionCode, defaultValue: question.selectedOption) },
                            set: { newValue in
                                viewModel.updateAnswer(for: question.questionCode, selectedOption: newValue)
                            }
                        )
                    )
                    
                }
                
                HTMLText(htmlString: healthCheckDetail.landingPage.questionsPage.healthContract,
                         fontType: .normal,
                         fontSize: .size14,
                         color: .slateGray)
                .padding(Spacing.space24)
                
                VVUIKit.DoubleDivider(color: Color.mediumGray, lineHeight: 1)
                    .padding(Spacing.space24)
                
                if !healthCheckDetail.landingPage.questionsPage.travelParty.partyMembers.isEmpty {
                    
                    HealthCheckTravelPartyView(
                        travelParty: healthCheckDetail.landingPage.questionsPage.travelParty,
                        onSelectionChanged: { selectedIds in
                            viewModel.updateSelectedPartyMembers(selectedIds)
                        }
                    )
                    
                }
                
                VStack() {
                    
                    PrimaryButton("Save responses", isDisabled: !viewModel.areAllQuestionsAnswered()) {
                        viewModel.updateHealthCheck()
                    }
                    
                    LinkButton("Cancel", action: {
                        viewModel.didTapCancel = true
                    })
                    .foregroundStyle(Color.darkGray)
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, Spacing.space8)
                .padding(.horizontal, Spacing.space8)
                .padding(.bottom, Spacing.space40)
            }
        }
        .fullScreenCover(isPresented: $viewModel.didTapCancel) {
            
            VVSheetModal(title: healthCheckDetail.healthCheckRefusePage.title,
                         subheadline: healthCheckDetail.healthCheckRefusePage.description,
                         primaryButtonText: "Ok, Got it",
                         imageName: nil,
                         imageURL: healthCheckDetail.healthCheckRefusePage.imageURL,
                         primaryButtonAction: {
                
                viewModel.didTapCancel = false
                
            }, dismiss: {
                
                viewModel.didTapCancel = false
            })
            .background(Color.clear)
            .transition(.opacity)
        }
        .fullScreenCover(isPresented: $viewModel.isHealthCheckFailedPageNotEmpty) {
            
            VVSheetModal(title: viewModel.updateHealthCheckDetailRequestResult?.healthCheckFailedPage.title,
                         subheadline: viewModel.updateHealthCheckDetailRequestResult?.healthCheckFailedPage.description,
                         primaryButtonText: "Ok, Got it",
                         imageName: nil,
                         imageURL: viewModel.updateHealthCheckDetailRequestResult?.healthCheckFailedPage.imageURL,
                         primaryButtonAction: {
                
                viewModel.goToHomeScreen()
                
            }, dismiss: {
                
                viewModel.goToHomeScreen()
            })
            .background(Color.clear)
            .transition(.opacity)
        }
        .fullScreenCover(isPresented: $viewModel.didFailToUpdateHealthCheck) {
            
            VVSheetModal(title: viewModel.errorMessage,
                         primaryButtonText: "OK",
                         primaryButtonAction: {
                viewModel.didFailToUpdateHealthCheck = false
            }, dismiss: {
                viewModel.didFailToUpdateHealthCheck = false
            })
            .background(Color.clear)
            .transition(.opacity)
            
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("")
        
    }
    
    private func backButton() -> some View {
        
        HStack {
            
            BackButton({
                viewModel.onBackButtonTapped()
            }, isCircleButton: false)
            .opacity(0.8)
            
            Spacer()
        }
        .padding(.leading, Spacing.space16)
    }
    
}


#Preview {
    HealthCheckQuestionScreenView(viewModel: HealthCheckQuestionPreviewViewModel(),
                                  healthCheckDetail: HealthCheckDetail.sample())
}

struct HealthCheckQuestionPreviewViewModel: HealthCheckQuestionViewModelProtocol {
    
    func areAllQuestionsAnswered() -> Bool {
        return false
    }
    
    var updateHealthCheckDetailRequestResult: UpdateHealthCheckDetailRequestResult?
    
    var isHealthCheckFailedPageNotEmpty: Bool = false
    var didFailToUpdateHealthCheck: Bool = false
    var errorMessage: String?
    var didTapCancel: Bool = false
    
    func onBackButtonTapped() {
        
    }
    
    func goToHomeScreen() {
        
    }
    
    func initializeQuestions(_ questions: [HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion]) {
        
    }
    
    func updateAnswer(for questionCode: String, selectedOption: String) {
        
    }
    
    func getCurrentAnswer(for questionCode: String, defaultValue: String) -> String {
        return ""
    }
    
    func updateHealthCheck() {
        
    }
    
    func updateSelectedPartyMembers(_ memberIds: Set<String>) {
        
    }
}

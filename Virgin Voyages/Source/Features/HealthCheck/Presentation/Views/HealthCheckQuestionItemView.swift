//
//  HealthCheckQuestionItemView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/5/25.
//

import SwiftUI
import VVUIKit

struct HealthCheckQuestionItemView: View {
    
    let healthCheckQuestion: HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion
    
    @Binding var selectedOption: String
    
    init(healthCheckQuestion: HealthCheckDetail.LandingPage.QuestionsPage.HealthQuestion,
         selectedOption: Binding<String>) {
        
        self.healthCheckQuestion = healthCheckQuestion
        self._selectedOption = selectedOption
    }
    
    var body: some View {
        VStack(spacing: Spacing.space24) {
            
            questionTitleAndDescription()
            
            questionButtonSelection()
            
            VVUIKit.DoubleDivider(color: Color.mediumGray, lineHeight: 1)
            
        }
        .padding(Spacing.space24)
    }
    
    private func questionTitleAndDescription() -> some View {
        
        VStack(alignment: .leading, spacing: Spacing.space12) {
            
            Text(healthCheckQuestion.title)
                .foregroundStyle(Color.darkGray)
                .font(.vvHeading5Bold)
            
            HTMLText(htmlString: healthCheckQuestion.question,
                     fontType: .normal,
                     fontSize: .size14,
                     color: .slateGray)
        }
        
    }
    
    private func questionButtonSelection() -> some View {
        
        HStackLayout(spacing: Spacing.space12) {
            
            ForEach(healthCheckQuestion.options, id: \.self) { option in
                
                CapsuleToggleButton(title: option,
                                    selectedOption: $selectedOption) {
                    
                    selectedOption = option
                    
                }
                
            }
        }
        .padding(.vertical, Spacing.space16)
        
    }
}

#Preview {
    HealthCheckQuestionItemView(healthCheckQuestion: HealthCheckDetail.sample().landingPage.questionsPage.healthQuestions.first!, selectedOption: .constant("Yes"))
}

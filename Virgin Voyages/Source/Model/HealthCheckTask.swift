//
//  HealthSurvey.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/6/23.
//

import SwiftUI

@Observable class HealthCheckTask {
	var questions: [Question]
	var contract: String
	var confirmationQuestion: String
	var title: String
	
	init(content: Endpoint.GetHealthCheck.Response) {
		var items: [Question] = []
		for question in content.landingPage.questionsPage.healthQuestions {
			items += [Question(question: question)]
		}
		
		questions = items
		contract = content.landingPage.questionsPage.healthContract
		confirmationQuestion = content.landingPage.questionsPage.confirmationQuestion
		title = content.landingPage.title
	}
	
	var answers: [Endpoint.UpdateHealthCheck.Request.HealthQuestion]? {
		var responses: [Endpoint.UpdateHealthCheck.Request.HealthQuestion] = []
		for question in questions {
			let code = question.id
			let answer = question.answer
			if answer != "" {
				responses += [.init(questionCode: code, selectedOption: answer)]
			} else {
				return nil
			}
		}
		
		return responses
	}
}

extension HealthCheckTask {
	@Observable class Question: Identifiable {
		var id: String
		var title: String
		var body: String
		var options: [String]
		var answer: String
		
		init(question: Endpoint.GetHealthCheck.Response.LandingPage.QuestionsPage.HealthQuestion) {
			id = question.questionCode
			title = question.title
			body = question.question
			options = question.options
			answer = ""
		}
	}
}

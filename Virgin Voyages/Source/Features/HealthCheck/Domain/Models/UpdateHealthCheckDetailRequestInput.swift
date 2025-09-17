//
//  UpdateHealthCheckDetailRequestInput.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

struct UpdateHealthCheckDetailRequestInput {
    
    let healthQuestions: [HealthQuestion]
    let signForOtherGuests: [String]
    
    struct HealthQuestion: Codable {
        let questionCode: String
        let selectedOption: String
    }
    
}

extension UpdateHealthCheckDetailRequestInput {
    
    static func sample() -> UpdateHealthCheckDetailRequestInput {
        return UpdateHealthCheckDetailRequestInput(
            healthQuestions: [
                HealthQuestion(questionCode: "UI003120", selectedOption: "NO"),
                HealthQuestion(questionCode: "UI003121", selectedOption: "NO"),
                HealthQuestion(questionCode: "UI004315", selectedOption: "NO")
            ],
            signForOtherGuests: []
        )
    }
    
}

//
//  UpdateHealthCheckDetailRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

extension UpdateHealthCheckDetailRequestInput {
    
    func toNetworkDto() -> UpdateHealthCheckDetailRequestBody {
        return .init(healthQuestions: self.healthQuestions.map { $0.toNetworkDto() },
                     signForOtherGuests: self.signForOtherGuests)
    }
}

extension UpdateHealthCheckDetailRequestInput.HealthQuestion {
    
    func toNetworkDto() -> UpdateHealthCheckDetailRequestBody.HealthQuestion {
        return .init(questionCode: self.questionCode, selectedOption: self.selectedOption)
    }
}

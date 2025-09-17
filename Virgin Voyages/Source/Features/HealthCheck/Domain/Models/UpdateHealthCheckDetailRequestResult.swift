//
//  UpdateHealthCheckDetailRequestResult.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

struct UpdateHealthCheckDetailRequestResult {
    let isHealthCheckComplete: Bool
    let isFitToTravel: Bool
    let healthCheckFailedPage: HealthCheckFailedPage
    
    struct HealthCheckFailedPage: Codable {
        let imageURL: String
        let title: String
        let description: String
    }
}

extension UpdateHealthCheckDetailRequestResult {
    static func sample() -> UpdateHealthCheckDetailRequestResult {
        UpdateHealthCheckDetailRequestResult(isHealthCheckComplete: true,
                                             isFitToTravel: true, healthCheckFailedPage: .empty())
    }
}

extension UpdateHealthCheckDetailRequestResult.HealthCheckFailedPage {
    
    static func empty() -> UpdateHealthCheckDetailRequestResult.HealthCheckFailedPage {
        UpdateHealthCheckDetailRequestResult.HealthCheckFailedPage(imageURL: "",
                                                                   title: "",
                                                                   description: "")
    }
}

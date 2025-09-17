//
//  UpdateHealthCheckDetailResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

extension UpdateHealthCheckDetailResponse {
    
    func toDomain() -> UpdateHealthCheckDetailRequestResult {
        return .init(isHealthCheckComplete: self.isHealthCheckComplete.value,
                     isFitToTravel: self.isFitToTravel.value,
                     healthCheckFailedPage: self.healthCheckFailedPage?.toDoamin() ?? .empty())
    }
}

extension UpdateHealthCheckDetailResponse.HealthCheckFailedPage {
    
    func toDoamin() -> UpdateHealthCheckDetailRequestResult.HealthCheckFailedPage {
        return .init(imageURL: self.imageURL.value,
                     title: self.title.value,
                     description: self.description.value)
    }
}

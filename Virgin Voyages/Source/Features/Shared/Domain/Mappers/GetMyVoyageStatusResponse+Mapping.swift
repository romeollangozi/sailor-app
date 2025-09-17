//
//  GetMyVoyageStatusResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation

extension GetMyVoyageStatusResponse {
    func toDomain() -> SailingMode {
        if let voyageStatus = self.voyageStatus {
            return .init(rawValue: voyageStatus) ?? .undefined
        } else {
            return .undefined
        }
    }
}

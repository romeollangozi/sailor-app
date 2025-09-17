//
//  GetHomeNotificationsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.3.25.
//

import Foundation

extension GetHomeNotificationsResponse {
    func toDomain() -> HomeNotificationsSection {
        return HomeNotificationsSection(
            id: UUID().uuidString,
            unReadCount: unReadCount.value,
            title: title.value,
            summary: summary.value,
            createdAt: createdAt.value
        )
    }
}


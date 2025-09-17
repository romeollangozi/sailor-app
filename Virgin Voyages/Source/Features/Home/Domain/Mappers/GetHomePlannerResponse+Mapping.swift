//
//  GetHomePlannerResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 21.3.25.
//

import Foundation

extension GetHomePlannerResponse {
    func toDomain() -> HomePlannerSection {
        return HomePlannerSection(
            id: UUID().uuidString,
            key: .planner,
            nextEatery: HomePlannerSection.PlannerNextEatery(
                name: nextEatery?.name ?? "",
                time: nextEatery?.time ?? ""
            ),
            nextActivity: HomePlannerSection.PlannerNextActivity(
                appointmentId: nextActivity?.appointmentId ?? "",
                bookableType: BookableType(rawValue: nextActivity?.bookableType ?? "") ?? .eatery,
                imageUrl: nextActivity?.imageUrl ?? "",
                time: nextActivity?.timePeriod ?? "",
                title: nextActivity?.title ?? "",
                location: nextActivity?.location ?? "",
                inventoryState: InventoryState(rawValue: nextActivity?.inventoryState ?? "") ?? .nonInventoried
            ),
            upcomingEntertainments: (upComingEntertainments ?? []).map {
                HomePlannerSection.PlannerUpcomingEntertainment(
                    id: $0.id ?? "",
                    title: $0.title ?? "",
                    timePeriod: $0.timePeriod ?? "",
                    location: $0.location ?? ""
                )
            }
        )
    }
}

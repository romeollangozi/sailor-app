//
//  HomePlannerSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 21.3.25.
//

import Foundation

struct HomePlannerSection: HomeSection, Equatable {
    var id: String
    var key: SectionKey = .planner
    var nextEatery: PlannerNextEatery
    var nextActivity: PlannerNextActivity
    var upcomingEntertainments: [PlannerUpcomingEntertainment]

    struct PlannerNextEatery: Equatable {
        var name: String
        var time: String
    }
    
    struct PlannerNextActivity: Equatable {
        var appointmentId: String
        var bookableType: BookableType
        var imageUrl: String
        var time: String
        var title: String
        var location: String
        var inventoryState: InventoryState
    }
    
    struct PlannerUpcomingEntertainment: Equatable {
        let uuid: UUID = UUID()
        var id: String
        var title: String
        var timePeriod: String
        var location: String
    }
}

extension HomePlannerSection {
    static func empty() -> HomePlannerSection {
        return HomePlannerSection(
            id: UUID().uuidString,
            key: .planner,
            nextEatery: PlannerNextEatery(
                name: "",
                time: ""
            ),
            nextActivity: PlannerNextActivity(
                appointmentId: "",
                bookableType: .eatery,
                imageUrl: "",
                time: "",
                title: "",
                location: "",
                inventoryState: .nonInventoried
            ),
            upcomingEntertainments: []
        )
    }
    
    static func sample() -> HomePlannerSection {
            return HomePlannerSection(
                id: UUID().uuidString,
                key: .planner,
                nextEatery: PlannerNextEatery(
                    name: "Razzle Dazzle",
                    time: "5:45pm"
                ),
                nextActivity: PlannerNextActivity(
                    appointmentId: "11",
                    bookableType: .shoreExcursion,
                    imageUrl: "https://example.com/activity.jpg",
                    time: "8pm",
                    title: "Bahamas Beach",
                    location: "An evening of jazz and cocktails",
                    inventoryState: .nonInventoried
                ),
                upcomingEntertainments: [
                    PlannerUpcomingEntertainment(
                        id: "111",
                        title: "Comedy Show",
                        timePeriod: "9:30am-10am",
                        location: "The Red Room, Deck 6"
                    ),
                    PlannerUpcomingEntertainment(
                        id: "112",
                        title: "Magic Show",
                        timePeriod: "9:30am-10am",
                        location: "The Red Room, Deck 6"
                    )
                ]
            )
        }
    }

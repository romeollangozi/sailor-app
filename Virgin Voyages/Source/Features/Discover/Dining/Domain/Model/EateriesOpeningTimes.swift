//
//  EateriesOpeningTimes.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

struct EateriesOpeningTimes {
    struct Venue {
        struct Restaurant {
            struct OperationalHours {
                let fromTime: String
                let toTime: String
            }
            
            let name: String
            let externalId: String
            let deckLocation: String
            let operationalHours: [OperationalHours]
            let actionUrl: String
            let state: RestaurantState
            let isBookable: Bool
        }
        
        let name: String
        let restaurants: [Restaurant]
    }
    
    struct CMSContent {
        struct Text {
            let openingTimesHeading: String
        }
        
        let text: Text
    }
    
    let venues: [Venue]
    let isPreVoyageBookingStopped: Bool
    let cmsContent: CMSContent

    enum RestaurantState: String {
        case unavailable = "NOT_AVAILABLE"
        case available = "AVAILABLE"
        case closed = "CLOSED"
    }
}

extension EateriesOpeningTimes {
    static func map(from response: GetEateriesOpeningTimesResponse) -> EateriesOpeningTimes {
        return EateriesOpeningTimes(
            venues: response.venues?.compactMap { venue in
                Venue(
                    name: venue.name ?? "",
                    restaurants: venue.restaurants?.compactMap { restaurant in
                        Venue.Restaurant(
                            name: restaurant.name ?? "",
                            externalId: restaurant.externalId ?? "",
                            deckLocation: restaurant.deckLocation ?? "",
                            operationalHours: restaurant.operationalHours?.compactMap { hours in
                                Venue.Restaurant.OperationalHours(
                                    fromTime: hours.fromTime ?? "",
                                    toTime: hours.toTime ?? ""
                                )
                            } ?? [],
                            actionUrl: restaurant.actionUrl ?? "",
                            state: EateriesOpeningTimes.RestaurantState(rawValue: restaurant.state ?? "") ?? .unavailable,
                            isBookable: venue.name == "Restaurant"
                        )
                    } ?? []
                )
            } ?? [],
            isPreVoyageBookingStopped: response.isPreVoyageBookingStopped ?? false,
            cmsContent: EateriesOpeningTimes.CMSContent(
                text: EateriesOpeningTimes.CMSContent.Text(
                    openingTimesHeading: response.cmsContent?.text?.openingTimesHeading ?? ""
                )
            )
        )
    }
}

extension EateriesOpeningTimes {
    static var sample: EateriesOpeningTimes {
        EateriesOpeningTimes(
            venues: [
                .init(
                    name: "The Galley",
                    restaurants: [
                        .init(
                            name: "Test Resto",
                            externalId: "1",
                            deckLocation: "Deck 7",
                            operationalHours: [.init(fromTime: "08:00", toTime: "10:00")],
                            actionUrl: "",
                            state: .available,
                            isBookable: true
                        ),
                        .init(
                            name: "Closed Resto",
                            externalId: "2",
                            deckLocation: "Deck 8",
                            operationalHours: [],
                            actionUrl: "",
                            state: .closed,
                            isBookable: false
                        )
                    ]
                )
            ],
            isPreVoyageBookingStopped: false,
            cmsContent: .init(text: .init(openingTimesHeading: "Today's Opening Times"))
        )
    }
}

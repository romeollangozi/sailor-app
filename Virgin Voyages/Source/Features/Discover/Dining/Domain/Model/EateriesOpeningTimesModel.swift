//
//  EateriesOpeningTimesModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

import Foundation

struct EateriesOpeningTimesModel {
    struct Venue : Equatable {
        struct Restaurant : Equatable {
            let name: String
            let slug: String
            let venueId: String
            let operationalHours: String
            let isBookable: Bool
            let id: String = UUID().uuidString
        }
        
        let name: String
        let restaurants: [Restaurant]
        let id: String = UUID().uuidString
    }
    
    let venues: [Venue]
    let isPreVoyageBookingStopped: Bool
}

extension EateriesOpeningTimesModel {
    struct Labels {
        let openingTimesUnavailable: String
        let closedText: String
    }
}

extension EateriesOpeningTimesModel {
    
    static func map(eateriesOpeningTimes: EateriesOpeningTimes, eateriesList: EateriesList, labels: Labels) -> EateriesOpeningTimesModel {
           let venues = eateriesOpeningTimes.venues.map { venue in
               let restaurants: [EateriesOpeningTimesModel.Venue.Restaurant] = venue.restaurants.compactMap { restaurant in
                   guard let matchingEatery = eateriesList.findEatery(byExternalId: restaurant.externalId) else {
                       return nil
                   }

                   let operationalHours: String
                   switch restaurant.state {
                   case .closed:
                       operationalHours = labels.closedText
                   case .unavailable:
                       operationalHours = labels.openingTimesUnavailable.replacingOccurrences(of: ", ", with: "\n")
                   default:
                       operationalHours = restaurant.operationalHours
                           .map { "\($0.fromTime) - \($0.toTime)" }
                           .joined(separator: "\n")
                   }
                   
                   return EateriesOpeningTimesModel.Venue.Restaurant(
                    name: "\(restaurant.name), \(restaurant.deckLocation)",
                       slug: matchingEatery.slug,
                       venueId: matchingEatery.venueId,
                       operationalHours: operationalHours,
                       isBookable: restaurant.isBookable
                   )
               }
            
               return EateriesOpeningTimesModel.Venue(
                   name: venue.name,
                   restaurants: restaurants
               )
           }
           
           return EateriesOpeningTimesModel(
               venues: venues,
               isPreVoyageBookingStopped: eateriesOpeningTimes.isPreVoyageBookingStopped
           )
       }
    
    static var empty = EateriesOpeningTimesModel(
        venues: [],
        isPreVoyageBookingStopped: false
    )
    
    static var sample = EateriesOpeningTimesModel(
        venues: [
            .init(
                name: "Restaurant",
                restaurants: [
                    .init(name: "Pink Agave, Deck 5 Aft", slug: "", venueId: "", operationalHours: "6:00 AM - 6:00 AM", isBookable: true),
                    .init(name: "Extra Virgin, Deck 6 Mid", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: true),
                    .init(name: "The Wake, Deck 7 Aft", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: true),
                   ]
            ),
            .init(
                name: "The Galley",
                restaurants: [
                    .init(name: "Well bread, Deck 15 Mid-Aft", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: false),
                    .init(name: "Diner & Dash, Deck 15 Mid-Aft", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: false),
                    .init(name: "Noodle Around, Deck 15 Mid", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: false),
                    ]
            ),
            .init(
                name: "Eateries",
                restaurants: [
                    .init(name: "Lick Me Till...Ice Cream, Deck 7 Mid", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: false),
                    .init(name: "The Social Club Diner, Deck 7 Mid-Aft", slug: "", venueId: "",operationalHours: "6:00 AM - 6:00 AM", isBookable: false),
                ]
            )
        ],
        isPreVoyageBookingStopped: false
    )
}

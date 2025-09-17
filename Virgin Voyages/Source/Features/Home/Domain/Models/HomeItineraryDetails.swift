//
//  HomeItineraryDetails.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.4.25.
//

import Foundation

struct HomeItineraryDetails: Equatable, Hashable {
    let imageUrl: String
    let title: String
    let ship: String
    let date: String
    let itinerary: [ItineraryItem]

    struct ItineraryItem: Equatable, Hashable {
        let itineraryDay: Int
        let name: String
        let time: String?
        let info: String?
        let icon: IconType
        let link: String?

        static func empty() -> ItineraryItem {
            .init(
                itineraryDay: 1,
                name: "",
                time: "",
                info: "",
                icon: .marker,
                link: ""
            )
        }

        static func sample() -> [ItineraryItem] {
            return [
                  .init(
                      itineraryDay: 1,
                      name: "Barcelona",
                      time: "Departs at 6pm, local time",
                      info: "All aboard 2 hrs before departure",
                      icon: .marker,
                      link: "https://cert.gcpshore.virginvoyages.com/Web-Marketing/destinations/caribbean-cruises/miami"
                  ),
                  .init(
                      itineraryDay: 2,
                      name: "Marseille (Provence)",
                      time: "08:00am–07:00pm, local time",
                      info: nil,
                      icon: .anchor,
                      link: "https://cert.gcpshore.virginvoyages.com/Web-Marketing/destinations/caribbean-cruises/miami"
                  ),
                  .init(
                      itineraryDay: 3,
                      name: "Cannes",
                      time: "8am–1pm, local time",
                      info: nil,
                      icon: .anchor,
                      link: "https://cert.gcpshore.virginvoyages.com/Web-Marketing/destinations/caribbean-cruises/miami"
                  ),
                  .init(
                      itineraryDay: 4,
                      name: "Sea day",
                      time: nil,
                      info: nil,
                      icon: .ship,
                      link: nil
                  )
              ]
        }
    }

    enum IconType: String {
        case marker
        case anchor
        case ship
    }
}
extension HomeItineraryDetails {
    static func empty() -> HomeItineraryDetails {
        .init(
            imageUrl: "",
            title: "",
            ship: "",
            date: "",
            itinerary: []
        )
    }

    static func sample() -> HomeItineraryDetails {
        .init(
            imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:5acc4e20-ee81-4ad2-bdf8-2062521b6e6d/IMG-MAP-DEST-Caribbean-Riviera-Maya-1600x900.jpg",
            title: "French Daze and Ibiza Nights",
            ship: "Sailing on Scarlet Lady",
            date: "10-16 Aug, 2024",
            itinerary: ItineraryItem.sample()
        )
    }
}

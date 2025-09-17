//
//  GetHomeItineraryDetailsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.4.25.
//

import Foundation

extension GetItineraryDetailsResponse {
    func toDomain() -> HomeItineraryDetails {
        return HomeItineraryDetails(
            imageUrl: self.imageUrl.value,
            title: self.title.value,
            ship: self.ship.value,
            date: self.date.value,
            itinerary: self.itinerary?.map { itinerary in
                HomeItineraryDetails.ItineraryItem(
                    itineraryDay: itinerary.itineraryDay.value,
                    name: itinerary.name.value,
                    time: itinerary.time,
                    info: itinerary.note,
                    icon: HomeItineraryDetails.IconType(rawValue: itinerary.icon?.rawValue ?? "") ?? .anchor,
                    link: itinerary.link
                    )
            } ?? []
        )
    }
}

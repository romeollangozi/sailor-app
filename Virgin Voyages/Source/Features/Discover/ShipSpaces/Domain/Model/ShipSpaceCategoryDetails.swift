//
//  ShipSpaceCategoryDetails.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import Foundation

struct ShipSpaceCategoryDetails: Equatable {
    let imageUrl: String
    let header: String
    let subHeader: String
    let shipSpaces: [ShipSpaceDetails]
    let leadTime: LeadTime
}

extension ShipSpaceCategoryDetails {
    static func map(from response: GetShipSpaceCategoryResponse) -> ShipSpaceCategoryDetails {
        return ShipSpaceCategoryDetails(
            imageUrl: response.imageUrl ?? "",
            header: response.header ?? "",
            subHeader: response.subHeader ?? "",
            shipSpaces: response.shipSpaces?.map { space in
                ShipSpaceDetails(
                    id: space.id ?? "",
                    imageUrl: space.imageUrl ?? "",
                    landscapeThumbnailUrl: space.landscapeThumbnailUrl ?? "",
                    name: space.name ?? "",
                    location: space.location ?? "",
                    introduction: space.introduction ?? "",
                    shortDescription: space.shortDescription ?? "",
                    longDescription: space.longDescription ?? "",
                    needToKnows: space.needToKnows ?? [],
                    editorialBlocks: space.editorialBlocks ?? [],
                    openingTimes: space.openingTimes?.map {
                        ShipSpaceDetails.OpeningTime(
                            fromToDay: $0.fromToDay ?? "",
                            fromToTime: $0.fromToTime ?? ""
                        )
                    } ?? [],
                    treatmentCategories: space.treatmentCategories?.map { category in
                        ShipSpaceDetails.TreatmentCategory(
                            name: category.name ?? "",
                            subCategories: category.subCategories?.map { subCategory in
                                ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory(
                                    name: subCategory.name ?? "",
                                    treatments: subCategory.treatments?.map { treatment in
                                        ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory.Treatment(
                                            id: treatment.id ?? "",
                                            name: treatment.name ?? "",
                                            imageUrl: treatment.imageUrl ?? ""
                                        )
                                    } ?? []
                                )
                            } ?? []
                        )
                    } ?? []
                )
            } ?? [],
            leadTime: LeadTime(
                title: response.leadTime?.title ?? "",
                description:  response.leadTime?.description ?? "",
                imageUrl:  response.leadTime?.imageUrl ?? "",
                date:  response.leadTime?.date?.iso8601 ?? Date(),
                isCountdownStarted:  response.leadTime?.isCountdownStarted ?? false,
                timeLeftToBookingStartInSeconds:  response.leadTime?.timeLeftToBookingStartInSeconds ?? 0
            )
        )
    }
}

extension ShipSpaceCategoryDetails {
    static func sample() -> ShipSpaceCategoryDetails {
        return ShipSpaceCategoryDetails(
            imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:26de751a-1cb8-481c-9169-e8e26530a7da/IMG-WEL-Redemption-Spa-Achitectural-S16-015-v1-750x420.jpg",
            header: "Beauty & Body",
            subHeader: "All the onboard spots to primp, polish, coif, style and groom.",
            shipSpaces: [
                ShipSpaceDetails.sample()
            ],
            leadTime: LeadTime.sample()
        )
    }
    
    static func empty() -> ShipSpaceCategoryDetails {
        return ShipSpaceCategoryDetails(
            imageUrl: "",
            header: "",
            subHeader: "",
            shipSpaces: [],
            leadTime: LeadTime.empty()
        )
    }
}

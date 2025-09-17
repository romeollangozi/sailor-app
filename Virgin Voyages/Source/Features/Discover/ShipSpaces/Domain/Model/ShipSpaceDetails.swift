//
//  ShipSpaceDetails.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 2.2.25.
//

import Foundation

struct ShipSpaceDetails: Hashable {
    struct OpeningTime: Hashable {
        let fromToDay: String
        let fromToTime: String
    }
    
    struct TreatmentCategory: Hashable {
        struct TreatmentSubCategory: Hashable {
            struct Treatment: Hashable {
                let id: String
                let name: String
                let imageUrl: String
            }
            let name: String
            let treatments: [Treatment]
        }
        let name: String
        let subCategories: [TreatmentSubCategory]
    }
    
    let id: String
    let imageUrl: String
    let landscapeThumbnailUrl: String
    let name: String
    let location: String
    let introduction: String
    let shortDescription: String
    let longDescription: String
    let needToKnows: [String]
    let editorialBlocks: [String]
    let openingTimes: [OpeningTime]
    let treatmentCategories: [TreatmentCategory]
}

extension ShipSpaceDetails {
    static func sample() -> ShipSpaceDetails {
        return ShipSpaceDetails(
            id: "5a4bf485da0c112a66ed6201",
            imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:d7bad028-3fa1-4c53-a34d-7d0a91e13a6c/IMG-WEL-redemption-spa-architectural-interior-main-entrance-v1-01-S16_491-1200x1440.jpg",
            landscapeThumbnailUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:d7bad028-3fa1-4c53-a34d-7d0a91e13a6c/IMG-WEL-redemption-spa-architectural-interior-main-entrance-v1-01-S16_491-1200x1440.jpg",
            name: "Redemption Spa",
            location: "Deck 5 Mid",
            introduction: "At Redemption, we've harnessed the soothing power of the ocean in everything we do, from dynamic flotation treatments to revitalizing deep sea algae wraps, using the finest products made with natural, organic ingredients.",
            shortDescription: "A luxurious spa experience with ocean-inspired treatments.",
            longDescription: "If vacation for you isn’t complete without the ultimate form of self-care, our spa will be your second home. From massages so good they’ll make you question life itself, to a mudroom that will revitalize your body and soul, we call it Redemption for a reason. Our Thermal Suite includes a mud room, salt room, sauna, steam room, hot and cold plunge pools and heated marble hammam benches – so many ways to reveal a new version of you.",
            needToKnows: [
                "Arrive at least 15 minutes before your treatment to relax and prepare.",
                "Cancellations must be made at least 24 hours in advance for a full refund."
            ],
            editorialBlocks: [
                "Unwind in our Thermal Suite, featuring hot and cold plunge pools, a mud room, and a salt room."
            ],
            openingTimes: [
                ShipSpaceDetails.OpeningTime(fromToDay: "Friday", fromToTime: "6:00am - 10:00pm"),
                ShipSpaceDetails.OpeningTime(fromToDay: "Saturday", fromToTime: "6:00am - 10:00pm")
            ],
            treatmentCategories: [
                ShipSpaceDetails.TreatmentCategory(
                    name: "Thermal Suite",
                    subCategories: [
                        ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory(
                            name: "Massages",
                            treatments: [
                                ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory.Treatment(
                                    id: "123445",
                                    name: "Deliverance Hot Mineral Massage",
                                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:6989fdc8-f9f1-4365-bc1e-0385a437984f/IMG-Deliverance-Hot-Mineral-Massage-Stocksy-Large-2155440-1200x800.jpg"
                                ),
                                ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory.Treatment(
                                    id: "1020408",
                                    name: "Absolution Quartz Bed Massage",
                                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:13503bb0-18f4-4f5c-bde1-291d790429a5/IMG-Absolution-Quartz-Bed-Massage-GettyImages-487143990-1200x800.jpg"
                                )
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    static func empty() -> ShipSpaceDetails {
        return ShipSpaceDetails(
            id: "",
            imageUrl: "",
            landscapeThumbnailUrl: "",
            name: "",
            location: "",
            introduction: "",
            shortDescription: "",
            longDescription: "",
            needToKnows: [],
            editorialBlocks: [],
            openingTimes: [],
            treatmentCategories: []
        )
    }
}

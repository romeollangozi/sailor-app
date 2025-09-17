//
//  ShipSpacesModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.1.25.
//

import Foundation

struct ShipSpacesCategories: Equatable {
    let header: String
    let subHeader: String
    let shipMapText: String
    let categories: [ShipCategory]
}

struct ShipCategory: Equatable {
    let code: String
    let name: String
    let imageUrl: String
}

extension ShipSpacesCategories {
    static func map(from response: GetShipSpacesResponse) -> ShipSpacesCategories {
        return ShipSpacesCategories(
            header: response.header ?? "",
            subHeader: response.subHeader ?? "",
            shipMapText: response.shipMapText ?? "",
            categories: response.categories?.map { space in
                ShipCategory(
                    code: space.code.value, // Assuming 'name' corresponds to 'code'
                    name: space.name.value,
                    imageUrl: space.imageUrl.value
                )
            } ?? []
        )
    }
}

extension ShipSpacesCategories {
    static func sample() -> ShipSpacesCategories {
        return ShipSpacesCategories(
            header: "Ship Spaces",
            subHeader: "Take a look at everywhere (and everything) you can get into on each deck.",
            shipMapText: "View the Shipmap",
            categories: [
                ShipCategory(
                    code: "Eateries",
                    name: "Eateries",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:8f02aa8f-fde1-4540-a058-5bd05937a998/IMG-FNB-Pink-Agave-Architectural-S13-067-v1-750x420.jpg"
                ),
                ShipCategory(
                    code: "Bars---Clubs",
                    name: "Bars & Clubs",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:ee980a01-2c27-4a63-9793-a912d1bf99ff/IMG-FNB-Sip-Architectural-v1-750x420.jpg"
                ),
                ShipCategory(
                    code: "Live-venues",
                    name: "Live Venues",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:b7af9a62-efb0-437c-9fd0-6d6115ac9389/IMG-ENT-another-rose-singer-v1-0641-750x420.jpg"
                ),
                ShipCategory(
                    code: "Fitness",
                    name: "Fitness",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:c9628aba-72b6-419b-9390-825176bc093b/IMG-WEL-B-Complex-Burn-Row-750x420.jpg"
                ),
                ShipCategory(
                    code: "Hang-outs",
                    name: "Hang outs",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:0051db13-20b0-4dbb-87c9-3204a498600f/IMG-WEL-AQUATIC-CLUB-POOL-V1-750x420.jpg"
                ),
                ShipCategory(
                    code: "Beauty---Body",
                    name: "Beauty & Body",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:26de751a-1cb8-481c-9169-e8e26530a7da/IMG-WEL-Redemption-Spa-Achitectural-S16-015-v1-750x420.jpg"
                ),
                ShipCategory(
                    code: "Shops",
                    name: "Shops",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:3648d9ea-0b66-4232-9358-4fdb531e19e1/IMG-RET-High-Street-Virgin-Shop-v1-750x420.jpg"
                ),
                ShipCategory(
                    code: "Services",
                    name: "Services",
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:b3d8276d-023f-4843-8cd3-46c6170b8206/IMG-SPC-sailor-services-lifestyle-v1-7096-750x420.jpg"
                )
            ]
        )
    }
    
    static func empty() -> ShipSpacesCategories {
        return ShipSpacesCategories(
            header: "",
            subHeader: "",
            shipMapText: "",
            categories: []
        )
    }
}

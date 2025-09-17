//
//  ShipEatsOpeninTime.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.5.25.
//

struct ShipEatsOpeninTime {
    public let imageURL: String
    public var title: String
    public let subtitle: String
}


extension ShipEatsOpeninTime {
    public static func empty() -> ShipEatsOpeninTime {
        return ShipEatsOpeninTime(
            imageURL: "",
            title: "",
            subtitle: ""
        )
    }
}

extension ShipEatsOpeninTime {
    public static func sample() -> ShipEatsOpeninTime {
        return ShipEatsOpeninTime(
            imageURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:c0128d47-18b0-40d3-9ee5-23fb286d5e6f/RENDER-presail-ship-eats-food-314x314.jpg",
            title: "ShipEats Delivery opens shipboard!",
            subtitle: "Pop back when you’re onboard to order food delivery to your cabin from select venues across the ship. And, of course to pre-order breakfast in bed!"
        )
    }
}

//
//  EateryLocalizationResources.swift
//  Virgin Voyages
//
//  Created by Pajtim on 29.8.25.
//

import Foundation

struct EateryLocalizationResources: Equatable {
    let partySizeInfoDrawerBody: String
    let partySizeInfoDrawerHeading: String
    let diningReservationsShipboardModalHeading: String
    let diningReservationsShipboardModalSubHeading: String
    let diningReservationsShipboardModalSubHeading1: String
    let soldOutReadMore: String
    let gotItCta: String
    let selectTimeSlotSubheading: String

    static func empty() -> EateryLocalizationResources {
        .init(
            partySizeInfoDrawerBody: "",
            partySizeInfoDrawerHeading: "",
            diningReservationsShipboardModalHeading: "",
            diningReservationsShipboardModalSubHeading: "",
            diningReservationsShipboardModalSubHeading1: "",
            soldOutReadMore: "",
            gotItCta: "",
            selectTimeSlotSubheading: ""
        )
    }
}

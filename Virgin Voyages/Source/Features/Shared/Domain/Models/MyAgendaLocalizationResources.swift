//
//  MyAgendaLocalizationResources.swift
//  Virgin Voyages
//
//  Created by Pajtim on 5.8.25.
//

import Foundation

struct MyAgendaLocalizationResources {
    let emptyAgendaMessage: String
    let yourPreviewAgendaText: String
    let portDayLabel: String

    static func defaultResources() -> MyAgendaLocalizationResources {
        return .init(
            emptyAgendaMessage: "You don’t currently have any bookings for this day, go ahead and fill your boots!",
            yourPreviewAgendaText: "Your Agenda Preview",
            portDayLabel: "Port day: {Port Name}"
        )
    }
}

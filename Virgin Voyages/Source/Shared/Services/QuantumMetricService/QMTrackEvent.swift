//
//  QMTrackEvent.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.2.25.
//

import Foundation

typealias QMEvent = (id: Int, value: String)

enum QMTrackEvent {
    case buttonTapped(event: QMEvent)
    
    var details: QMEvent {
        switch self {
        case .buttonTapped(let event):
            return event
        }
    }
}

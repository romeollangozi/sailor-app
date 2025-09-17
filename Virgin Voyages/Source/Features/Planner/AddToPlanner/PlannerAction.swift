//
//  PlannerAction.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.9.25.
//

import Foundation

struct PlannerAction: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let action: () -> Void

    static func == (lhs: PlannerAction, rhs: PlannerAction) -> Bool {
        lhs.id == rhs.id
    }
}


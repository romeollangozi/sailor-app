//
//  Sailor.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/8/24.
//

import Foundation
import Observation

struct Sailor: Identifiable, Equatable, Hashable {
	var id: String // reservationGuestId
	var reservationGuestId: String { id } 
	var userId: String // guestId
	var reservationId: String
	var reservationNumber: String
	var photoUrl: URL?
	var firstName: String
	var lastName: String
	var displayName: String
	
	static func == (lhs: Sailor, rhs: Sailor) -> Bool {
		lhs.id == rhs.id
	}
}

extension Sailor {
    static func empty() -> Sailor {
        return Sailor(
            id: "",
            userId: "",
            reservationId: "",
            reservationNumber: "",
            photoUrl: nil,
            firstName: "",
            lastName: "",
            displayName: ""
        )
    }
}

//
//  ConflictState.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.3.25.
//


// MARK: - Enum for conflict status
enum ConflictState: String, Hashable {
	case hard = "Hard"
	case soft = "Soft"
	case available = "Available"
	case booked = "Booked"
	case `repeat` = "repeat"
}

//
//  BookableConflictsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.3.25.
//

extension Array where Element == BookableConflictsResponse {
	func toDomain() -> [BookableConflicts] {
		return map { $0.toDomain() }
	}
}

extension BookableConflictsResponse {
	func toDomain() -> BookableConflicts {
		return BookableConflicts(
			slotId: slotId.value,
			slotStatus: ConflictState(rawValue: slotStatus.value) ?? .available,
			sailors: sailors?.map { $0.toSailor() } ?? []
		)
	}
}

extension BookableConflictsResponse.Sailor {
	func toSailor() -> BookableConflicts.Sailor {
		return BookableConflicts.Sailor(
			reservationGuestId: reservationGuestId.value,
			status: ConflictState(rawValue: status.value) ?? .available,
			bookableType: BookableType(rawValue: bookableType.value) ?? BookableType.entertainment,
			appointmentId: appointmentId.value
		)
	}
}

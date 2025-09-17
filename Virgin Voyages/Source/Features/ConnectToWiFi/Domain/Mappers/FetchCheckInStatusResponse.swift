//
//  FetchCheckInStatusResponse.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/6/25.
//

extension FetchCheckInStatusResponse {
	func toDomain() -> CheckInStatus {
		return CheckInStatus(isGuestCheckedIn: isGuestCheckedIn,
							 isGuestOnBoard: isGuestOnBoard,
							 reservationGuestID: reservationGuestId)
	}
}

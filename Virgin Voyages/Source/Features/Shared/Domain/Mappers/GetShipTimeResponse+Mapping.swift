//
//  GetShipTimeResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//

import VVPersist

extension GetShipTimeResponse {
	func toDomain() -> ShipTime {
		return ShipTime(fromUTCDate: fromUtcDate, fromDateOffset: fromDateOffset)
	}
}

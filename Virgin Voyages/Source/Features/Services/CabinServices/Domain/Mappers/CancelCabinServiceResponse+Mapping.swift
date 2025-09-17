//
//  CancelCabinServiceResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

extension EmptyResponse {
	func toDomain() -> CancelCabinServiceRequestResult? {
		return .init()
	}
}

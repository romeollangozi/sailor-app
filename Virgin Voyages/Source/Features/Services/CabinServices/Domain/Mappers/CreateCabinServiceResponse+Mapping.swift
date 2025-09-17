//
//  CreateCabinServiceResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

extension CreateCabinServiceResponse {
	func toDomain() -> CreateCabinServiceRequestResult {
		return .init(requestId: self.requestId.value)
	}
}

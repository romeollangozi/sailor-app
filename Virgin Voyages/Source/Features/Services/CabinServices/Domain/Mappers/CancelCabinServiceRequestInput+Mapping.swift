//
//  CancelCabinServiceRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

//Need an extension method on CancelCabinServiceRequestInput to map CancelCabinServiceRequestInput to CancelCabinServiceRequest with name toNetworDto()


import Foundation

extension CancelCabinServiceRequestInput {
	func toNetworkDto() -> CancelCabinServiceRequestBody {
		return CancelCabinServiceRequestBody(requestId: self.requestId,
											 cabinNumber: self.cabinNumber,
											 status: "cancel",
											 activeRequest: self.activeRequest,
											 isV1: "true")
	}
}
			

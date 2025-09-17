//
//  CancelCabinServiceRequestInput.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

struct CancelCabinServiceRequestInput: Equatable {
	let requestId: String
	let cabinNumber: String
	let activeRequest: String
}

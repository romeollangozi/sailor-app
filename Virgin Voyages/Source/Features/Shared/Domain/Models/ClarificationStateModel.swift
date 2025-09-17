//
//  ClarificationStateModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.3.25.
//

struct ClarificationStateModel {
	let clarificationTitle: String
	let clarificationText: String
	let sailorPhotos: [String]
	let sailorNames: [String]
	let isCurrentSailorConfict: Bool
	let viewExistingBookingText: String
	let bookingType: String

	static let empty = ClarificationStateModel(
		clarificationTitle: "",
		clarificationText: "",
		sailorPhotos: [],
		sailorNames: [""],
		isCurrentSailorConfict: false,
		viewExistingBookingText: "View existing booking",
		bookingType: ""
	)
}

//
//  ScannedQRCodeErrorType.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 8.5.25.
//


enum ScannedQRCodeErrorType {
	case wrongVoyageNumber
	case wrongQrCode
	case isNotSailor

	struct ErrorInfo {
		let title: String
		let subtitle: String
	}

	var info: ErrorInfo {
		switch self {
		case .wrongVoyageNumber:
			return ErrorInfo(
				title: "Hmmm it’s one of ours but…",
				subtitle: "Looks like that sailor is on a different voyage! You can only add shipmates from your current voyage."
			)

		case .wrongQrCode:
			return ErrorInfo(
				title: "Hmmm that’s not one of ours…",
				subtitle: "That looks like a QR code, but not one of ours. Make sure to only scan your friends QR code, found in the Sailor App."
			)

		case .isNotSailor:
			return ErrorInfo(
				title: "Hmmm it’s one of ours but…",
				subtitle: "It doesn’t look like a sailor’s QR code. Make sure to only scan your friends QR code, found in the Sailor App."
			)
		}
	}
}

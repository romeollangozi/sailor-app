//
//  SailTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/22/24.
//

import Foundation

enum SailTask: CaseIterable, Identifiable {
	case welcome
	case voyageContract
	case securityPhoto
	case paymentMethod
	case emergencyContact
	case pregnancy
	case stepAboard
	case travelDocuments
	
	var id: String {
		switch self {
		case .voyageContract: "voyageContract"
		case .securityPhoto: "security"
		case .paymentMethod: "paymentMethod"
		case .emergencyContact: "emergencyContact"
		case .pregnancy: "pregnancy"
		case .stepAboard: "embarkationSlotSelection"
		case .travelDocuments: "travelDocuments"
		case .welcome: "welcome"
		}
	}
	
	var backgroundColorCode: String {
		switch self {
		case .voyageContract: "#fedc54"
		case .securityPhoto: "#b4b7c6"
		case .paymentMethod: "#8ED6EC"
		case .emergencyContact: "#aae0e8"
		case .pregnancy: "#f0cedf"
		case .stepAboard: "#F5C9CF"
		case .travelDocuments: "#faf2d4"
		case .welcome: "#551179"
		}
	}
}


//
//  DiscoverType.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.5.25.
//

enum DiscoverType: String {
	case shipSpace = "ShipSpaces"
	case lineUps = "LineUps"
	case shoreExcursions = "ShoreExcursions"
	case addOns = "AddOns"
	case undefined = "undefined"
	
	init(from string: String) {
		self = DiscoverType(rawValue: string) ?? .undefined
	}
	
	static func from(string: String?) -> DiscoverType {
		guard let string else { return .undefined }
		return DiscoverType(from: string)
	}
}

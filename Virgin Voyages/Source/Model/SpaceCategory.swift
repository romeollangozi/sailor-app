//
//  Space.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 12/9/23.
//

import Foundation

enum SpaceCategory: CustomStringConvertible {
	case eateries
	case beauty
	
	var description: String {
		switch self {
		case .eateries: return "Eateries"
		case .beauty: return "Beauty & Body"
		}
	}
}

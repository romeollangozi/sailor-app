//
//  AccountStatusDTO.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/24/25.
//

import Foundation

enum AccountStatusDTO: String, Codable {
	case active = "ACTIVE"
	case inactive = "INACTIVE"
	case pending = "PENDING"
}

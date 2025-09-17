//
//  InventoryState.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

enum InventoryState: String {
    case nonInventoried = "NonInventoried"
    case paidInventoried = "PaidInventoried"
    case nonPaidInventoried = "NonPaidInventoried"
	
	init(from string: String) {
		self = InventoryState(rawValue: string) ?? .nonInventoried
	}
	
	static func from(string: String?) -> InventoryState {
		guard let string else { return .nonInventoried }
		return InventoryState(from: string)
	}
}

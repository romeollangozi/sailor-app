//
//  SpaceMenuItem.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 12/6/23.
//

import Foundation

protocol VenueMenuItem: Decodable {
	var name: String { get set }
	var description: String? { get set }
}

extension VenueMenuItem {
	var trimmedName: String {
		name.trimmingCharacters(in: .whitespaces)
	}
	
	var title: String {
		let text = trimmedName
		return text.count > 0 ? text : (description ?? "")
	}
	
	var body: String? {
		let text = trimmedName
		return text.count > 0 ? description : nil
	}
}

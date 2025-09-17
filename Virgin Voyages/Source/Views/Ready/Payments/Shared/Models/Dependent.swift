//
//  Dependent.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class Dependent: Identifiable {
	var id: String
	var selected: Bool

	init(id: String, selected: Bool) {
		self.id = id
		self.selected = selected
	}
}

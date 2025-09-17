//
//  SailorPickerSailorViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/10/24.
//

import SwiftUI

struct SailorPickerSailorViewModel: SailorPickerSailorViewModelProtocol {
	var id: String
	var photoURL: URL?
	var displayName: String
    var isLessThan21YearsOld: Bool
    
	init(id: String, photoURL: URL? = nil, displayName: String, isLessThan21YearsOld: Bool = false) {
		self.id = id
		self.photoURL = photoURL
		self.displayName = displayName
        self.isLessThan21YearsOld = isLessThan21YearsOld
	}

	static func == (lhs: SailorPickerSailorViewModel, rhs: SailorPickerSailorViewModel) -> Bool {
		lhs.id == rhs.id
	}
}

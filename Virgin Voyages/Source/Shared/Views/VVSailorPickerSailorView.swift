//
//  SailorPickerSailorViewModelProtocol.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.1.25.
//

import SwiftUI

protocol VVSailorPickerViewModelProtocol {
	var sailors: [VVSailorPickerViewSailorViewModel] { get }
	var addNewButtonViewModel: VVSailorPickerViewAddNewButtonViewModel? { get }
	func toggleSailor(_ sailor: VVSailorPickerViewSailorViewModel)
}

extension VVSailorPickerViewModelProtocol {
	var numberOfSelectedSailors: Int {
		return sailors.count(where: { $0.state == .selected || $0.state == .hardClash || $0.state == .softClash || $0.state == .booked })
	}

	func toggleSailor(_ sailor: VVSailorPickerViewSailorViewModel) {
	}
}

enum VVSailorState {
	case selected
	case unselected
	case hardClash
	case softClash
	case booked
}

extension VVSailorState {
	mutating func toggle() {
		if self == .hardClash || self == .booked || self == .softClash {
			self = .unselected
			return
		}
		self = (self == .selected) ? .unselected : .selected
	}
}

struct VVSailorPickerViewSailorViewModel: Identifiable, Equatable, Hashable {
	let id: String
	var reservationGuestId: String
	var reservationNumber: String
	var displayName: String
	var photoURL: URL?
	var state: VVSailorState
}

protocol VVSailorPickerViewAddNewButtonViewModel {
	var imageName: String? { get }
	var title: String { get }
	func tappedAddNew()
}

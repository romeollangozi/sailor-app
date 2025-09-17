//
//  SailorPickerView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/10/24.
//

import SwiftUI

protocol SailorPickerSailorViewModelProtocol: Identifiable, Equatable {
	var id: String { get }
	var photoURL: URL? { get }
	var displayName: String { get }
}

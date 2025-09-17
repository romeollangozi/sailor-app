//
//  BookableSailorDetails.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/6/25.
//

import Foundation

protocol BookableSailorDetails {
	var personId: String { get }
	var reservationNumber: String { get }
	var guestId: String { get }
	var status: String? { get }
}

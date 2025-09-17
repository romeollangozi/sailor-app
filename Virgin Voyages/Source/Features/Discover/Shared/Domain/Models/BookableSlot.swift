//
//  BookableSlot.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/6/25.
//

import Foundation

protocol BookableSlot {
	var activitySlotCode: String { get }
	var startDate: String { get }
	var endDate: String { get }
}

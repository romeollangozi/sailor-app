//
//  ActivityBooking.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/6/25.
//

import Foundation

class ActivityBooking {
	var activity: BookableActivity
	var slot: BookableSlot
	var sailors: [BookableSailorDetails]
    var appointmentId: String?
    var appointmentLinkId: String?
	var payWithExistingCard: Bool = true
	var operationType: BookingOperationType = .book
    var bookableType: BookableType = .undefined

	init(activity: BookableActivity,
		 slot: BookableSlot,
		 sailors: [BookableSailorDetails],
         appointmentId: String?,
		 appointmentLinkId: String? = nil,
		 payWithExistingCard: Bool = true,
		 operationType: BookingOperationType = .book,
         bookableType: BookableType) {
		self.activity = activity
		self.slot = slot
		self.sailors = sailors
        self.appointmentId = appointmentId
		self.appointmentLinkId = appointmentLinkId
		self.payWithExistingCard = payWithExistingCard
		self.operationType = operationType
        self.bookableType = bookableType
	}
    
    var isEditing: Bool {
        switch operationType {
        case .book: return false
        case .edit: return true
        case .cancel: return false
        }
    }
}

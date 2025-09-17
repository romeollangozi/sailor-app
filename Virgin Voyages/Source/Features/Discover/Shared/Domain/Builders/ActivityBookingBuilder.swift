//
//  ActivityBookingBuilder.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/5/25.
//

import Foundation

enum ActivityBookingBuilderError: Error {
	case missingBookingDetails
}

enum BookingOperationType: String {
	case book = ""
	case edit = "EDIT"
    case cancel = "CANCEL"

	var stringValue: String? {
		switch self {
		case .book:
			return nil
		case .edit:
			return "EDIT"
        case .cancel:
            return "CANCEL"
		}
	}
}

class ActivityBookingBuilder {
	private var activity: BookableActivity?
	private var slot: BookableSlot?
	private var sailors: [BookableSailorDetails] = []
    private var appointmentId: String?
	private var appointmentLinkId: String?
	private var payWithExistingCard: Bool = true
	private var operationType: BookingOperationType = .book
    private var bookableType: BookableType = .undefined


	func setActivity(_ activity: BookableActivity) -> Self {
		self.activity = activity
		return self
	}

	func setSlot(_ slot: BookableSlot) -> Self {
		self.slot = slot
		return self
	}
    
    func setAppointmentId(_ appointmentId: String?) -> Self {
        self.appointmentId = appointmentId
        return self
    }

	func setAppointmentLinkId(_ appointmentLinkId: String?) -> Self {
		self.appointmentLinkId = appointmentLinkId
		return self
	}


	func setSailors(_ sailors: [BookableSailorDetails]) -> Self {
		self.sailors = sailors
		return self
	}

	func setPayWithExistingCard(_ value: Bool) -> Self {
		self.payWithExistingCard = value
		return self
	}

	func setOperationType(_ type: BookingOperationType) -> Self {
		self.operationType = type
		return self
	}
    
    func setBookableType(_ type: BookableType) -> Self {
        self.bookableType = type
        return self
    }

	func build() throws -> ActivityBooking {
		guard let activity = activity, let slot = slot else {
			throw ActivityBookingBuilderError.missingBookingDetails
		}
		return ActivityBooking(activity: activity,
							   slot: slot,
							   sailors: sailors,
                               appointmentId: appointmentId,
							   appointmentLinkId: appointmentLinkId,
							   payWithExistingCard: payWithExistingCard,
							   operationType: operationType,
                               bookableType: self.bookableType)
    }
}

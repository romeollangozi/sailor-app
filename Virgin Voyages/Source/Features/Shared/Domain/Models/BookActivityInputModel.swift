//
//  BookActivityInputModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.5.25.
//

import Foundation

struct BookActivityInputModel  {
	var activity: BookableActivity
	var slot: BookableSlot
	var sailorDetails: [BookableSailorDetails]
	var operationType: BookingOperationType
    var bookableType: BookableType
	var payWithExistingCard: Bool
    var appointmentId: String?
	var appointmentLinkId: String?
	
	init(activityCode: String,
		 categoryCode: String,
		 currencyCode: String,
		 totalAmount: Double,
		 slot: Slot,
		 sailors: [SailorModel],
		 operationType: BookingOperationType = .book,
         bookableType: BookableType,
		 payWithExistingCard: Bool = true,
         appointmentId: String?,
		 appointmentLinkId: String? = nil,
		 previousBookedSailors: [SailorModel] = []) {
		self.activity = BookableActivityInput(activityCode: activityCode, categoryCode: categoryCode, totalAmount: totalAmount, currencyCode: currencyCode)
		self.slot = slotInput(slot: slot)
		self.operationType = operationType
        self.bookableType = bookableType
		self.payWithExistingCard = payWithExistingCard
        self.appointmentId = appointmentId
		self.appointmentLinkId = appointmentLinkId
		
		
		self.sailorDetails = [] // Temporary initialization as it throws an comile error:  'self' used before all stored properties are initialized
		self.sailorDetails = createSailorDetails(operationType: operationType, sailors: sailors, previousBookedSailors: previousBookedSailors)
	}
	
	private func createSailorDetails(operationType: BookingOperationType,
									 sailors: [SailorModel],
									 previousBookedSailors: [SailorModel]) -> [BookableSailorDetails] {
		switch operationType {
			case .book:
				return createSailorsForCreate(sailors: sailors)
			case .edit:
				return createSailorsForUpdate(sailors: sailors, previousBookedSailors: previousBookedSailors)
			case .cancel:
				return createSailorsForCancel(sailors: sailors)
		}
	}
	
	private func createSailorsForCreate(sailors: [SailorModel]) -> [BookableSailorDetails] {
		return sailors.map {SailorInput(personId: $0.reservationGuestId, reservationNumber: $0.reservationNumber, guestId: $0.guestId, status: nil)}
	}
	
	private func createSailorsForUpdate(sailors: [SailorModel], previousBookedSailors: [SailorModel]) -> [BookableSailorDetails] {
		let sailorsWithEditBookingStatus = EditBookingSailorStatusCalculator.caclulate(previousBookedSailors: previousBookedSailors,
																					   newBookedSailors: sailors)
		
		var sailorsInput: [SailorInput] = []
		for (_, sailor) in sailorsWithEditBookingStatus.enumerated() {
			let status = sailor.value.rawValue.isEmpty ? nil : sailor.value.rawValue
			sailorsInput.append(.init(personId: sailor.key.reservationGuestId, reservationNumber: sailor.key.reservationNumber, guestId: sailor.key.guestId, status: status))
		}
		
		return sailorsInput
	}
	
	private func createSailorsForCancel(sailors: [SailorModel]) -> [BookableSailorDetails] {
		return sailors.map {SailorInput(personId: $0.reservationGuestId, reservationNumber: $0.reservationNumber, guestId: $0.guestId, status: EditBookingSailorStatus.cancelled.rawValue)}
	}
	
	struct SailorInput: BookableSailorDetails {
		var personId: String
		var reservationNumber: String
		var guestId: String
		var status: String?
	}
	
	struct slotInput: BookableSlot {
		var activitySlotCode: String
		var startDate: String
		var endDate: String
		
		init(slot: Slot) {
			self.activitySlotCode = slot.id
			self.startDate = slot.startDateTime.toISO8601()
			self.endDate = slot.endDateTime.toISO8601()
		}
	}
	
	struct BookableActivityInput: BookableActivity {
		var activityCode: String
		var categoryCode: String
		var totalAmount: Double
		var currencyCode: String
		
		init(activityCode: String, categoryCode: String, totalAmount: Double, currencyCode: String) {
			self.activityCode = activityCode
			self.categoryCode = categoryCode
			self.totalAmount = totalAmount
			self.currencyCode = currencyCode
		}
	}

}

//
//  TreatmentDetails.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 5.2.25.
//

import Foundation

struct TreatmentDetails: Equatable, Hashable {
	let id: String
	let name: String
	let location: String
	let imageUrl: String
	let introduction: String
	let longDescription: String
	let priceFormatted: String
	let status: SlotStatus
	let isBookingEnabled: Bool
	let bookButtonText: String
	let options: [TreatmentOption]
	let appointments: Appointments?

	static func == (lhs: TreatmentDetails, rhs: TreatmentDetails) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension TreatmentDetails {
	var firstAppointmentId: String {
		return appointments?.items.first?.id ?? ""
	}
}

struct TreatmentOption: Equatable, Hashable {
	let id: String
	let duration: String
	let currencyCode: String
	let categoryCode: String
	let price: Double
	let priceFormatted: String
	let inventoryState: InventoryState
	let bookingType: BookingType
	let slots: [Slot]
	let isPreVoyageBookingStopped: Bool
	let status: SlotStatus

	static func == (lhs: TreatmentOption, rhs: TreatmentOption) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	var eventDays: [Date] {
		let dates = slots.compactMap { $0.startDateTime }
		let uniqueDates = Set(dates.map { Calendar.current.startOfDay(for: $0) })
		return uniqueDates.sorted()
	}

	func slotsForDate(date: Date) -> [Slot] {
		return slots.filter { Calendar.current.isDate($0.startDateTime, inSameDayAs: date) }
	}

	var isMultiDayEvent: Bool {
		return bookingType == .multiDaySingleInstance || bookingType == .multiDayMultiInstance
	}
}

extension TreatmentDetails {
	static func map(from response: GetTreatmentDetailsResponse) -> TreatmentDetails {
		return TreatmentDetails(
			id: response.id.value,
			name: response.name.value,
			location: response.location.value,
			imageUrl: response.imageUrl.value,
			introduction: response.introduction.value,
			longDescription: response.longDescription.value,
			priceFormatted: response.priceFormatted.value,
			status: SlotStatus(rawValue: response.status.value) ?? .notAvailable,
			isBookingEnabled: response.isBookingEnabled.value,
			bookButtonText: response.bookButtonText.value,
			options: response.options?.map { option in
				TreatmentOption(
					id: option.id.value,
					duration: option.duration.value,
					currencyCode: option.currencyCode.value,
					categoryCode: option.categoryCode.value,
					price: option.price.value,
					priceFormatted: option.priceFormatted.value,
					inventoryState: InventoryState(rawValue: option.inventoryState.value) ?? .nonInventoried,
					bookingType: BookingType(rawValue: option.bookingType.value) ?? .singleDayMultiInstance,
					slots: (option.slots?.map({$0.toDomain()}) ?? [])
						 .uniqueSlots()
						 .sortedByStartDate(),
					isPreVoyageBookingStopped: option.isPreVoyageBookingStopped.value,
					status: SlotStatus(rawValue: option.status.value) ?? .notAvailable
				)
			} ?? [],
			appointments: response.appointments?.toDomain()
		)
	}

	static func sample() -> TreatmentDetails {
		return TreatmentDetails(
			id: "1020406",
			name: "Deliverance Hot Mineral Massage",
			location: "Redemption Spa, Deck 5 Mid",
			imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:6989fdc8-f9f1-4365-bc1e-0385a437984f/IMG-Deliverance-Hot-Mineral-Massage-Stocksy-Large-2155440-1200x800.jpg",
			introduction: "Invigorate yourself with our full-body treatment performed on the revolutionary amber and quartz crystal bed.",
			longDescription: "As you stretch out on our amber and quartz bed, this soothing massage (medium to deep pressure) uses a silky body balm enriched with powerful succinic acid &mdash; aimed to nourish and relax you while easing muscle tension through classic massage techniques and Psamotherapy.<br /><br /><br />&nbsp;",
			priceFormatted: "$45.00",
			status: SlotStatus.soldOut,
			isBookingEnabled: true,
			bookButtonText: "Book",
			options: [
				TreatmentOption(
					id: "12345",
					duration: "50 min",
					currencyCode: "USD",
					categoryCode: "SPA",
					price: 15.0,
					priceFormatted: "$15.00",
					inventoryState: .paidInventoried,
					bookingType: .multiDaySingleInstance,
					slots: [
						Slot(
							id: "6775114d260a140dc4e3561e",
							startDateTime: Date(),
							endDateTime: Date(),
							status: SlotStatus.soldOut,
							isBooked: true,
							inventoryCount: 10
						),
						Slot(
							id: "6775114f260a140dc4e36443",
							startDateTime: Date(),
							endDateTime: Date(),
							status: SlotStatus.available,
							isBooked: true,
							inventoryCount: 10
						)
					],
					isPreVoyageBookingStopped: false,
					status: .available
				),
				TreatmentOption(
					id: "123456",
					duration: "90 min",
					currencyCode: "USD",
					categoryCode: "SPA",
					price: 15.0,
					priceFormatted: "$25.00",
					inventoryState: .paidInventoried,
					bookingType: .multiDaySingleInstance,
					slots: [
						Slot(
							id: "6775114d260a140dc4e3561e",
							startDateTime: Date(),
							endDateTime: Date(),
							status: SlotStatus.soldOut,
							isBooked: true,
							inventoryCount: 10
						),
						Slot(
							id: "6775114f260a140dc4e36443",
							startDateTime: Date(),
							endDateTime: Date(),
							status: SlotStatus.available,
							isBooked: true,
							inventoryCount: 10
						)
					],
					isPreVoyageBookingStopped: false,
					status: .available
				)
			],
			appointments: Appointments(
				bannerText: "Booked: Multiple bookings",
				items: [
					AppointmentItem(
						id: "faf8b847-35f4-4a27-8676-f2b0f2a7d610",
						linkId: "",
                        slotId: "",
                        startDateTime: Date(),
						bannerText: "1 ticket, Wed July 20, 9am",
						sailors: [],
						isWithinCancellationWindow: false
					),
					AppointmentItem(
						id: "faf8b847-35f4-4a27-8676-f2b0f2a7d611",
						linkId: "",
						slotId: "",
                        startDateTime: Date(),
						bannerText: "2 tickets, Fri July 22, 9am",
						sailors: [],
						isWithinCancellationWindow: false
					)
				]
			)
		)
	}

	static func empty() -> TreatmentDetails {
		return TreatmentDetails(
			id: "",
			name: "",
			location: "",
			imageUrl: "",
			introduction: "",
			longDescription: "",
			priceFormatted: "",
			status: SlotStatus.notAvailable,
			isBookingEnabled: false,
			bookButtonText: "",
			options: [],
			appointments: nil
		)
	}
}

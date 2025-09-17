//
//  VoyageReservation.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/12/24.
//

import Foundation

struct VoyageReservation {
	var primarySailor: Sailor
	var sailors: [Sailor]
	var assistingSailor: Sailor?
	var reservationNumber: String
	var reservationId: String
	var packageName: String
	var voyageNumber: String
	var voyageId: String
	var shipCode: CruiseShip
	var cabinNumber: String
	var deckNumber: Int
	var startDate: Date
	var endDate: Date
	var embarkDate: Date
	var debarkDate: Date
	var days: [Date]
	var embarkPortCode: String
	var debarkPortCode: String
	
	init(reservation: Endpoint.GetVoyageReservation.Response, bookingInfo: Endpoint.GetUserProfile.Response.BookingInfo) {
		let voyage = reservation.voyageDetails
		packageName = voyage.voyageItinerary.packageName
		voyageNumber = voyage.voyageItinerary.voyageNumber
		voyageId = voyage.voyageItinerary.voyageId
		shipCode = voyage.shipCode
		cabinNumber = reservation.stateroomsDetail?.first?.stateroom ?? "No Cabin"
		deckNumber = Int(reservation.stateroomsDetail?.first?.deck ?? "0") ?? 0
		startDate = voyage.startDateTime.iso8601 ?? .now
		endDate = voyage.endDateTime.iso8601 ?? .now
		reservationNumber = reservation.reservationNumber
		reservationId = reservation.reservationId
		embarkDate = voyage.voyageItinerary.embarkDate.iso8601 ?? .now
		debarkDate = voyage.voyageItinerary.debarkDate.iso8601 ?? .now
		
		if let embarkCode = voyage.voyageItinerary.itineraryList.first?.portCode {
			embarkPortCode = embarkCode
		} else {
			embarkPortCode = ""
		}
		
		if let debarkCode = voyage.voyageItinerary.itineraryList.last?.portCode {
			debarkPortCode = debarkCode
		} else {
			debarkPortCode = ""
		}
		
		sailors = reservation.guestsSummary.map {
			.init(id: $0.reservationGuestId, userId: $0.guestId, reservationId: reservation.reservationId, reservationNumber: reservation.reservationNumber, firstName: $0.firstName, lastName: $0.lastName, displayName: $0.firstName.capitalized)
		}
		
		if let primary = sailors.first(where: { $0.userId == bookingInfo.guestId }) {
			primarySailor = primary
		} else {
			primarySailor = .init(id: bookingInfo.reservationGuestId, userId: bookingInfo.guestId, reservationId: reservation.reservationId, reservationNumber: reservation.reservationNumber, firstName: "", lastName: "", displayName: "Sailor")
		}
		
		var days: [Date] = []
		let components = Calendar.current.dateComponents([.day], from: startDate.startOfDay, to: endDate.startOfDay)
		let count = components.day ?? 0
		for day in 0...count {
			let startComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
			var dateComponents = DateComponents()
			dateComponents.year = startComponents.year ?? 0
			dateComponents.month = startComponents.month ?? 0
			dateComponents.day = (startComponents.day ?? 0) + day
			if let day = Calendar.current.date(from: dateComponents) {
				days += [day]
			}
		}
		
		self.days = days
	}
	
	var firstDay: Date {
		startDate.day
	}
	
	var currentDay: Date {
		Date.now < startDate ? firstDay : .now.day
	}
	
	var reservationGuestId: String {
		primarySailor.id
	}
	
	var guestId: String {
		primarySailor.userId
	}
	
	var fullName: String {
		primarySailor.displayName
	}
	
	func isSailing(shipTime: Date = .now) -> Bool {
		shipTime > startDate.startOfDay && shipTime < endDate.endOfDay
	}
}

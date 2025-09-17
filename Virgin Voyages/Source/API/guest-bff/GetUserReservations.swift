//
//  UserReservations.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/25/23.
//

import Foundation

extension Endpoint {
	struct GetUserReservations: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/guest-bff/voyage-account-settings/user/reservations"
		var method: Method = .get
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: NoQuery?
		
		// MARK: Response Data
		
		struct Response: Decodable {
			var profilePhotoURL: String
			var pageDetails: PageDetails
			var guestBookings: [GuestBooking]
			
			struct PageDetails: Decodable {
				var title: String // "Voyage selection"
				var buttons: Buttons
				var imageUrl: String // "https:\/\/int.virginvoyages.com\/svc\/dxpcore\/mediaitems\/e8b87907-d25e-4d02-8428-0a0005e50bfe"
				var description: String // "You've got some sweet sails coming up — so choose which specific voyage you'd like to view below."
				var labels: Labels
				
				struct Buttons: Decodable {
					var bookVoyage: String // "Book another voyage"
					var connectBooking: String // "Connect a booking"
				}
				
				struct Labels: Decodable {
					var date: String // "DATE"
					var archived: String // "ARCHIVED"
				}
			}
			
			struct GuestBooking: Decodable, Equatable {
				var embarkDate: String // "2023-10-22"
				var reservationGuestId: String // "d722916d-253d-4f22-91bb-de9eedc2f9d4"
				var portNames: [String?]
				var isArchivedBooking: Bool // false
				var reservationNumber: String // "505752"
				var voyageNumber: String // "RS23102214NAD"
				var ports: [String]
				var isPastBooking: Bool // false
				var imageUrl: String? // ""
				var shipName: String // "Resilient Lady"
				var guestId: String // "e1c8e6be-b183-46a9-86b7-c46fb1ae2eb7"
				var isActiveBooking: Bool // false
				var guestName: String // "CHRISTOPHER DESALVO"
				var voyageName: String // "Ancient Athens to Modern Dubai"
				var shipCode: CruiseShip // "RS"
				var voyageDate: String // "October 22-November 5 2023"
				var reservationId: String // "ed0935ae-fb45-43a6-8844-7b9950c8c908"
				var status: String // "Booked - PIP"
			}
		}
	}
}

// MARK: Extensions

extension Endpoint.GetUserReservations.Response {
	func sortedBookings() -> [GuestBooking] {
		var array: [GuestBooking] = []
		for booking in guestBookings {
			if !array.contains(where: { $0.reservationId == booking.reservationId }) {
				array += [booking]
			}
		}
		
		return array.filter {
			$0.isActiveBooking || !$0.isArchivedBooking
		}.sorted {
			let date1 = $0.embarkDate.iso8601 ?? .now
			let date2 = $1.embarkDate.iso8601 ?? .now
			return date1 < date2
		}
	}
}

extension Endpoint.GetUserReservations.Response.GuestBooking {
	var type: String {
		if isActiveBooking {
			return "Active"
		}
		
		if isPastBooking {
			return "Completed"
		}
		
		if isArchivedBooking {
			return "Archived"
		}
		
		return "Upcoming"
	}
}

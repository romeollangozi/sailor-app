//
//  UpdateEmbarkationSlotTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct UpdateEmbarkationSlotTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/embarkationslot"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
        
        init(task: EmbarkationTask, reservation: VoyageReservation) {
            let sailor = reservation.assistingSailor ?? reservation.primarySailor
            query = .init(reservationId: sailor.reservationId, guestId: sailor.reservationGuestId)
            request = task.saveRequest
        }
		
		struct Query: Encodable {
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			
			private enum CodingKeys: String, CodingKey {
				case reservationId = "reservation-id"
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var flightDetails: FlightDetails?
			var isPriorityBoardingGuest: Bool // false
			var isVIPGuest: Bool // false
			var slotNumber: Int? // 1
			var isParkingOpted: Bool? // false
			var optedByReservationGuestIds: [String] // ["133fc0f5-7ebc-49c4-9722-9f6aa5acfdaf"]
			var isFlyingIn: Bool? // false
			var isRockStarBoardingGuest: Bool // false
			var postCruiseInfo: PostCruiseInfo?
			
			struct PostCruiseInfo: Encodable {
				var optedByReservationGuestIds: [String]? // ["133fc0f5-7ebc-49c4-9722-9f6aa5acfdaf"]
				var flightDetails: FlightDetails?
				var isFlyingOut: Bool? // true
			}
			
			struct FlightDetails: Encodable {
				var number: String? // "6985"
				var airlineCode: String? // "Y6"
				var arrivalTime: String? // "18:30:00"
			}
		}
	}
}



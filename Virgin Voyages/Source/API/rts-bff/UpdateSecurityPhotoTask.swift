//
//  UpdateSecurityPhotoTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/29/24.
//

import Foundation

extension Endpoint {
	struct UpdateSecurityPhotoTask: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Endpoint.GetReadyToSail.UpdateTask
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/security"
		var method: Method = .put
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
		init(uploadPhoto: Photo, reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId)
			request = .init(securityPhotoURL: uploadPhoto.url.absoluteString, isDeleted: false)
		}
		
		init(deletePhoto: Photo, reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId)
			request = .init(securityPhotoURL: deletePhoto.url.absoluteString, isDeleted: true)
		}
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Request: Encodable {
			var securityPhotoURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
			var isDeleted: Bool // false
		}
	}
}

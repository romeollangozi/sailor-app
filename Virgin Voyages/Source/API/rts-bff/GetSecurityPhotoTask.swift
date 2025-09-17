//
//  GetSecurityPhotoTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/23.
//

import Foundation

extension Endpoint {
	struct GetSecurityPhotoTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/security"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			struct PhotoCapturedPage: Decodable {
				var caption: String // "Use photo?"
				var title: String // "Ahoy, gorgeous."
			}
			
			struct CameraButtonPage: Decodable {
				var description: String // ""
				var title: String // "Security photo"
				var imageURL: String // ""
			}
			
			var photoCapturedPage: PhotoCapturedPage
			var securityPhotoURL: String // "https:\/\/prod.virginvoyages.com\/dxpcore\/mediaitems\/51ec04dc-37fd-4008-9d70-0f3e26dce52b"
			var updateURL: String
			var cameraButtonPage: CameraButtonPage
		}
	}
}

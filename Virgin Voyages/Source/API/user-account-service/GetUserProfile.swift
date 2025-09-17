//
//  GetUserProfile.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/16/23.
//

import Foundation

extension Endpoint {
	struct GetUserProfile: Requestable {
		typealias RequestType = Request
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/user-account-service/userprofile"
		var method: Method = .get
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .any
		var pathComponent: String?
		var request: Request?
		var query: NoQuery?
		
		// MARK: Request Data
		
		struct Request: Encodable {
			
		}
		
		// MARK: Response Data
		
		struct Response: Decodable {
			
			struct BookingInfo: Decodable {
				var guestTypeCode: String? // "OTHER"
				var guestId: String // "e1c8e6be-b183-46a9-86b7-c46fb1ae2eb7"
				var embarkDate: String // "2023-04-19"
				var reservationNumber: String // "402508"
				var reservationGuestId: String // "fe777d31-5993-4803-896b-07789fac5a74"
			}
			
			struct UserNotification: Decodable {
				var userNotificationId: String // "a1S4o000001aeTkEAI"
				var notificationTypeCode: String // "NO"
				var isDeleted: Bool // false
				var userGUID: String? // "0a7da173-a785-416a-a14e-38515f222401"
				var userId: String? // "0a7da173-a785-416a-a14e-38515f222401"
			}
			
			var genderCode: String? // "M"
			var lastName: String // "DESALVO"
			var firstName: String // "CHRISTOPHER"
			var birthDate: String // "MM-DD-YYYY"
			var isPasswordExist: Bool // false
			var personId: String // "e1c8e6be-b183-46a9-86b7-c46fb1ae2eb7"
			var hasLinkedReservations: Bool // true
			var personTypeCode: String // "G"
			var emailVerificationStatus: String? // "VERIFIED"
			var phoneCountryCode: String? // "??"
			var photoUrl: String // ""
			var email: String // "christopherdesalvo@gmail.com"
			var phoneNumber: String?
			var bookingInfo: BookingInfo?
			var userNotifications: [UserNotification]
		}
	}
}

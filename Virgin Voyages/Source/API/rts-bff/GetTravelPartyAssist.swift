//
//  GetTravelPartyAssist.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct GetTravelPartyAssist: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/travelparty/assist"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			query = .init(guestId: reservation.reservationGuestId, reservationId: reservation.reservationId, reservationNumber: reservation.reservationNumber)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			var reservationNumber: String // 482996

			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
				case reservationId = "reservation-id"
				case reservationNumber = "reservation-number"
			}
		}
		
		struct Response: Decodable {
			struct LandingPage: Decodable {
				struct Buttons: Decodable {
					var reminder: String // "Send a reminder"
				}
				
				struct Labels: Decodable {
					var sailor: String // "Sailor {0}"
				}
				
				struct UnnamedSailorInfoModal: Decodable {
					var imageUrl: String? // null
					var title: String // "Make it ship shape"
					var description: String // "Before you complete Ready to Sail on behalf of your cabinmate, please provide their details on the website so we know exactly who is accompanying you on your sailing."
				}
				
				var buttons: Buttons
				var header: String // "Your sailing party"
				var description: String // "You can complete essential sailing tasks for members of your travel party."
				var inCompleteTaskCaption: String // "SAILORS THAT NEED A HAND"
				var completedTaskCaption: String // "SAILORS COMPLETE"
				var labels: Labels
				var unnamedSailorInfoModal: UnnamedSailorInfoModal
			}
			
			struct Sailor: Decodable {
				var name: String // "Frankie A"
				var photoURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
				var gender: String? // "M"
				var outstandingTasksText: String // "3 tasks outstanding"
				var detailURL: String // "{rts-bff_base_url}/security?reservation-guest-id=12346"
				var reservationGuestId: String // "eebaf5a1-9ff5-447c-a1ba-b18847e5d392"
				var reservationNumber: String // "1237794"
			}
			
			var landingPage: LandingPage
			var incompleteTaskSailors: [Sailor]
			var completedTaskSailors: [Sailor]
			var isPaymentTaskLocked: Bool // true
			var loggedInReservationGuestId: String // "c6c76153-f600-4edd-81bc-0086b858af42"
			var totalSailorCount: Int // 5
			var sailorCountWithNoData: Int // 3
		}
	}
}

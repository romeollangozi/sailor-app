//
//  ReservationSummary.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/16/23.
//

import Foundation

extension Endpoint {
	struct GetVoyageReservation: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/dxpcore/reservation/summary"
		var method: Endpoint.Method = .get
		var cachePolicy: Endpoint.CachePolicy = .always
		var scope: RequestScope = .any
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservationNumber: String) {
			query = .init(reservationNumber: reservationNumber, excludeCancelled: "true")
		}
		
		struct Query: Encodable {
			var reservationNumber: String // 402508
			var excludeCancelled: String = "true" // Bool // true
			
			private enum CodingKeys: String, CodingKey {
				case reservationNumber = "reservation-number"
				case excludeCancelled = "exclude-cancelled"
			}
		}
		
		// MARK: Response Data
		
		struct Response: Codable {
			var _links: Links
			var stateroomsDetail: [Stateroom]?
			var guestsSummary: [GuestSummary]
			var paymentStatusCode: String // "FP"
			var reservationId: String // "a45c3a44-7d3a-41ac-809a-da3db915c350"
			var reservationStatusCode: String // "RS"
			var reservationNumber: String // "402508"
			var voyageDetails: VoyageDetails
			var guestCount: Int? // 1
			
			struct GuestSummary: Codable {
				var genderCode: String // "M"
				var reservationGuestId: String // "fe777d31-5993-4803-896b-07789fac5a74"
				var lastName: String // "DESALVO"
				var firstName: String // "CHRISTOPHER"
                var birthDate: String? // "1983-07-15"
                var embarkDate: String // "2023-04-19"
				var embarkPortCode: String // "MIA"
				var guestId: String // "e1c8e6be-b183-46a9-86b7-c46fb1ae2eb7"
				var debarkDate: String // "2023-04-23"
				var debarkPortCode: String // "MIA"
				var stateroom: String // "9122Z"
				var email: String?
				var isGuestOnBoard: Bool // false
				var isResident: Bool // true
				var isValidated: Bool // false
				var isPrimaryGuest: Bool // true
				var isVIP: Bool // false
				var totalPercentageCheckinStatus: Int // 0
			}
			
			struct Links: Codable {
				var detailInfo: Link
				var selfInfo: Link
				
				private enum CodingKeys: String, CodingKey {
					case detailInfo = "detail-info"
					case selfInfo = "self"
				}
				
				struct Link: Codable {
					var href: String
				}
			}
			
			struct Stateroom: Codable {
				var stateroomCategoryCode: String // "TC"
				var stateroom: String // "9122Z"
				var stateroomCategory: String // "Central Sea Terrace"
				var additionalAttributeCodes: [String?]? // ["STARBOARD", "MIDSHIP"]
				var deck: String // "9"
			}
			
			struct VoyageDetails: Codable {
				var region: String? // "CARIBBEAN"
				var endDate: String // "2023-04-23"
				var startDate: String // "2023-04-19"
				var voyageItinerary: VoyageItinerary
				var endDateTime: String // "2023-04-23T06:30:00
				var startDateTime: String // "2023-04-19T18:00:00"
				var shipName: String // "Scarlet Lady"
				var shipCode: CruiseShip // "SC"
				
				struct VoyageItinerary: Codable {
					var voyageName: String // "Fire and Sunset Soirées"
					var voyageId: String // "15910b51-a480-4337-ab1e-a3d982fd117a"
					var itineraryList: [Itinerary]
					var embarkDate: String // "2023-04-19"
					var debarkDate: String // "2023-04-23"
					var voyageNumber: String // "SC2304194NKW"
					var packageCode: String // "4NKW"
					var packageName: String // "Fire and Sunset Soirées"
					
					struct Itinerary: Codable {
						var itineraryDay: Int // 1
						var isSeaDay: Bool // false
						var portCode: String? // "MIA"
					}
				}
			}
		}
	}
}

// Temporarily mapping SailorReservationSummary to Endpoint.GetVoyageReservation.Response(legacy) in order not to introduce more refactoring.
extension Endpoint.GetVoyageReservation.Response {
    init(from summary: SailorReservationSummary) {
        let shipCodeEnum = CruiseShip(rawValue: summary.voyageDetails.shipCode) ?? .any

        let regionValue: String? = (summary.voyageDetails.region).value

        // Staterooms
        let staterooms: [Stateroom] = summary.stateroomsDetail.map {
            Stateroom(
                stateroomCategoryCode: $0.stateroomCategoryCode,
                stateroom: $0.stateroom,
                stateroomCategory: $0.stateroomCategory,
                additionalAttributeCodes: $0.additionalAttributeCodes.map { Optional($0) },
                deck: $0.deck
            )
        }

        // Guests
        let guests: [GuestSummary] = summary.guestsSummary.map {
            GuestSummary(
                genderCode: $0.genderCode,
                reservationGuestId: $0.reservationGuestId,
                lastName: $0.lastName,
                firstName: $0.firstName,
                birthDate: $0.birthDate,
                embarkDate: $0.embarkDate,
                embarkPortCode: $0.embarkPortCode,
                guestId: $0.guestId,
                debarkDate: $0.debarkDate,
                debarkPortCode: $0.debarkPortCode,
                stateroom: $0.stateroom,
                email: $0.email,
                isGuestOnBoard: $0.isGuestOnBoard,
                isResident: $0.isResident,
                isValidated: $0.isValidated,
                isPrimaryGuest: $0.isPrimaryGuest,
                isVIP: $0.isVIP,
                totalPercentageCheckinStatus: Int($0.totalPercentageCheckinStatus.rounded())
            )
        }

        // Itinerary
        let itinerary: [VoyageDetails.VoyageItinerary.Itinerary] =
            summary.voyageDetails.voyageItinerary.itineraryList.map {
                VoyageDetails.VoyageItinerary.Itinerary(
                    itineraryDay: $0.itineraryDay,
                    isSeaDay: $0.isSeaDay,
                    portCode: $0.portCode
                )
            }

        let voyageItinerary = VoyageDetails.VoyageItinerary(
            voyageName: summary.voyageDetails.voyageItinerary.voyageName,
            voyageId: summary.voyageDetails.voyageItinerary.voyageId,
            itineraryList: itinerary,
            embarkDate: summary.voyageDetails.voyageItinerary.embarkDate,
            debarkDate: summary.voyageDetails.voyageItinerary.debarkDate,
            voyageNumber: summary.voyageDetails.voyageItinerary.voyageNumber,
            packageCode: summary.voyageDetails.voyageItinerary.packageCode,
            packageName: summary.voyageDetails.voyageItinerary.packageName
        )

        let voyageDetails = VoyageDetails(
            region: regionValue,
            endDate: summary.voyageDetails.endDate,
            startDate: summary.voyageDetails.startDate,
            voyageItinerary: voyageItinerary,
            endDateTime: summary.voyageDetails.endDateTime,
            startDateTime: summary.voyageDetails.startDateTime,
            shipName: summary.voyageDetails.shipName,
            shipCode: shipCodeEnum
        )

        let links = Links(
            detailInfo: Links.Link(href: summary.links.detailInfo.href),
            selfInfo: Links.Link(href: summary.links.selfLink.href)
        )

        self.init(
            _links: links,
            stateroomsDetail: staterooms.isEmpty ? nil : staterooms,
            guestsSummary: guests,
            paymentStatusCode: summary.paymentStatusCode,
            reservationId: summary.reservationId,
            reservationStatusCode: summary.reservationStatusCode,
            reservationNumber: summary.reservationNumber,
            voyageDetails: voyageDetails,
            guestCount: summary.guestCount
        )
    }
}


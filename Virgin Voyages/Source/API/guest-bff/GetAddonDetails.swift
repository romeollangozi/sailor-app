//
//  GetAddonDetails.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/15/24.
//

import Foundation

extension Endpoint {
    struct GetAddonDetails: Requestable {
        typealias RequestType = NoRequest
        typealias QueryType = Query
        typealias ResponseType = Response
        var authenticationType: AuthenticationType = .user
        var path = "/guest-bff/addon/details/v2"
        var method: Method = .get
        var cachePolicy: CachePolicy = .always
        var scope: RequestScope = .any
        var pathComponent: String?
        var request: NoRequest?
        var query: Query?
        
        init(reservation: VoyageReservation) {
            query = .init(reservationNumber: reservation.reservationNumber, guestId: reservation.guestId, shipCode: reservation.shipCode, embarkDate: reservation.startDate.format(.iso8601date))
        }
        
        init(reservation: VoyageReservation, code: String?) {
			if let addonCode = code {
				query = .init(reservationNumber: reservation.reservationNumber, guestId: reservation.guestId, shipCode: reservation.shipCode, code: addonCode)

			} else {
				query = .init(reservationNumber: reservation.reservationNumber, guestId: reservation.guestId, shipCode: reservation.shipCode, embarkDate: reservation.startDate.format(.iso8601date))
			}
        }
        
        
        struct Query: Encodable {
            var reservationNumber: String
            var guestId: String
            var shipCode: CruiseShip
            var embarkDate: String?
            var code: String?
            
            private enum CodingKeys: String, CodingKey {
                case reservationNumber = "reservation-number"
                case guestId
                case shipCode
                case embarkDate
                case code
            }
        }
        
        struct Response: Decodable {
            // MARK: - AddonDetailsDTO
            var cmsContent: CMSContentDTO
            var addOns: [AddOnDTO] = []
            var bookingConfirmationImage: String?
        }
    }
}
        
       

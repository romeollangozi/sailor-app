//
//  GetReservationSummaryRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

import Foundation

struct GetSailorReservationSummary: AuthenticatedHTTPRequestProtocol {
    let reservationNumber: String

    var path: String {
        return NetworkServiceEndpoint.sailorReservationSummary
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationNumber: URLQueryItem = .init(name: "reservation-number", value: self.reservationNumber)
        let excludeCanel: URLQueryItem = .init(name: "exclude-cancelled", value: "true")

        return [reservationNumber, excludeCanel]
    }
}

struct GetSailorReservationSummaryResponse: Decodable {
    var voyageDetails: VoyageDetails?
    var reservationId: String?
    var reservationNumber: String?
    var paymentStatusCode: String?
    var reservationStatusCode: String?
    var stateroomsDetail: [StateroomDetail]?
    var guestCount: Int?
    var guestsSummary: [GuestSummary]?
    var _links: Links?
    
    struct VoyageDetails: Decodable {
        var startDate: String?
        var endDate: String?
        var shipCode: String?
        var shipName: String?
        var voyageItinerary: VoyageItinerary?
        var startDateTime: String?
        var endDateTime: String?
        var region: String?
        
        struct VoyageItinerary: Decodable {
            var voyageName: String?
            var voyageNumber: String?
            var voyageId: String?
            var packageCode: String?
            var packageName: String?
            var embarkDate: String?
            var debarkDate: String?
            var itineraryList: [ItineraryItem]?
            
            struct ItineraryItem: Decodable {
                var itineraryDay: Int?
                var isSeaDay: Bool?
                var portCode: String?
            }
        }
    }
    
    struct StateroomDetail: Decodable {
        var stateroom: String?
        var deck: String?
        var stateroomCategory: String?
        var stateroomCategoryCode: String?
        var additionalAttributeCodes: [String?]?
    }
    
    struct GuestSummary: Decodable {
        var firstName: String?
        var lastName: String?
        var genderCode: String?
        var birthDate: String?
        var email: String?
        var reservationGuestId: String?
        var guestId: String?
        var isPrimaryGuest: Bool?
        var isVIP: Bool?
        var totalPercentageCheckinStatus: Double?
        var isGuestOnBoard: Bool?
        var isResident: Bool?
        var isValidated: Bool?
        var stateroom: String?
        var embarkDate: String?
        var debarkDate: String?
        var embarkPortCode: String?
        var debarkPortCode: String?
    }
    
    struct Links: Decodable {
        var detailInfo: LinkDetail?
        var selfLink: LinkDetail?
        
        enum CodingKeys: String, CodingKey {
            case detailInfo = "detail-info"
            case selfLink = "self"
        }
        
        struct LinkDetail: Codable {
            var href: String?
        }
    }
}

extension NetworkServiceProtocol {
    func getSailorReservationSummary(reservationNumber: String) async throws -> GetSailorReservationSummaryResponse? {
        let request = GetSailorReservationSummary(reservationNumber: reservationNumber)
        return try await self.requestV2(request, responseModel: GetSailorReservationSummaryResponse.self)
    }
}

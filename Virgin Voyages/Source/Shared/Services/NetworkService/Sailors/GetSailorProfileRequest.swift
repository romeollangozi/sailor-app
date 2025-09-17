//
//  GetSailorsProfileRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Foundation

struct GetSailorsProfileRequest: AuthenticatedHTTPRequestProtocol {
    let reservationNumber: String?

    var path: String {
        return NetworkServiceEndpoint.sailorProfile
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        if let reservationNumber {
            let reservationNumber: URLQueryItem = .init(name: "reservationNumber", value: reservationNumber)

            return [reservationNumber]
        }
        return nil
    }
}

struct GetSailorsProfileResponse: Decodable {
    var userId: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var preferredName: String?
    var genderCode: String?
    var photoUrl: String?
    var birthDate: String?
    var citizenshipCountryCode: String?
    var phoneCountryCode: String?
    var phoneNumber: String?
    var type: String?
    var typeCode: String?
	var errorState: String?
    var reservation: Reservation?
    var upcomingReservation: Reservation?
	var externalRefId: String?
    
    struct Reservation: Codable {
        var status: String?
        var shipCode: String?
        var shipName: String?
        var isPassed: Bool?
        var voyageId: String?
        var voyageNumber: String?
        var embarkDate: String?
        var debarkDate: String?
        var embarkDateTime: String?
        var debarkDateTime: String?
        var reservationId: String?
        var reservationNumber: String?
        var cabinNumber: String?
        var guestId: String?
        var reservationGuestId: String?
        var deckPlanUrl: String?
        var itineraries: [Itinerary]?
    }
    
    struct Itinerary: Codable {
        var dayType: String?
        var dayNumber: Int?
        var date: String?
        var dayOfWeekCode: String?
        var dayOfWeek: String?
        var dayOfMonth: String?
        var isPortDay: Bool?
        var portCode: String?
        var portName: String?
    }
}

extension NetworkServiceProtocol {
    func getSailorsProfile(reservationNumber: String? = nil) async throws -> GetSailorsProfileResponse? {
        let request = GetSailorsProfileRequest(reservationNumber: reservationNumber)
        return try await self.requestV2(request, responseModel: GetSailorsProfileResponse.self)
    }
}

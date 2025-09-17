//
//  GetSailorReservationsRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

struct GetSailorReservationsRequest: AuthenticatedHTTPRequestProtocol {
    var path: String {
        return NetworkServiceEndpoint.sailorReservations
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetSailorReservationsResponse: Decodable {
    var profilePhotoURL: String?
    var pageDetails: PageDetails?
    var guestBookings: [GuestBooking]?
    
    struct PageDetails: Decodable {
        var buttons: Buttons?
        var imageUrl: String?
        var description: String?
        var title: String?
        var labels: Labels?
    }

    struct Buttons: Decodable {
        var bookVoyage: String?
        var connectBooking: String?
    }

    struct Labels: Decodable {
        var date: String?
        var archived: String?
    }

    struct GuestBooking: Decodable {
        var guestName: String?
        var voyageDate: String?
        var voyageName: String?
        var ports: [String?]?
        var reservationNumber: String?
        var guestId: String?
        var reservationGuestId: String?
        var reservationId: String?
        var portNames: [String?]?
        var voyageNumber: String?
        var status: String?
        var isPastBooking: Bool?
        var isActiveBooking: Bool?
        var imageUrl: String?
        var embarkDate: String?
        var shipCode: String?
        var shipName: String?
        var isArchivedBooking: Bool?
        var portsMapping: [PortMapping]?
    }

    struct PortMapping: Decodable {
        var name: String?
        var externalId: String?
    }
}

extension NetworkServiceProtocol {
    func getSailorReservations() async throws -> GetSailorReservationsResponse? {
        let request = GetSailorReservationsRequest()
        return try await self.requestV2(request, responseModel: GetSailorReservationsResponse.self)
    }
}



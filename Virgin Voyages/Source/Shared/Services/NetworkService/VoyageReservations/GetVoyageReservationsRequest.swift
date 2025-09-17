//
//  GetVoyageReservationRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 1.6.25.
//

import Foundation

struct GetVoyageReservationsRequest: AuthenticatedHTTPRequestProtocol {


    var path: String {
        return NetworkServiceEndpoint.voyageReservations
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct VoyageReservationsResponse: Decodable {
    var profilePhotoURL: String?
    var pageDetails: PageDetails?
    var guestBookings: [GuestBooking]?
    
    struct PageDetails: Codable {
        var buttons: Buttons?
        var imageUrl: String?
        var description: String?
        var title: String?
        var labels: Labels?
        
        struct Buttons: Codable {
            var bookVoyage: String?
            var connectBooking: String?
        }

        struct Labels: Codable {
            var date: String?
            var archived: String?
        }
    }

    struct GuestBooking: Codable {
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
        var bookedDate: String?
        
        struct PortMapping: Codable {
            var name: String?
            var externalId: String?
        }
    }
}


extension NetworkServiceProtocol {
    func getVoyageReservations(cacheOption: CacheOption = .noCache()) async throws -> VoyageReservationsResponse? {
        let request = GetVoyageReservationsRequest()
        return try await self.requestV2(request, responseModel: VoyageReservationsResponse.self, cacheOption: cacheOption)
    }
}

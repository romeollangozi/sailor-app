//
//  GetHomePlannerRequest.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 21.3.25.
//


import Foundation

struct GetHomePlannerRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetHomePlannerDataInput
    
    var path: String {
        return NetworkServiceEndpoint.getHomePlanner
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "reservationNumber", value: input.reservationNumber),
            .init(name: "reservationGuestId", value: input.reservationGuestId),
            .init(name: "shipCode", value: input.shipCode),
            .init(name: "voyageNumber", value: input.voyageNumber)
        ]
    }
}

struct GetHomePlannerDataInput {
    let reservationNumber: String
    let reservationGuestId: String
    let shipCode: String
    let voyageNumber: String
}

struct GetHomePlannerResponse: Codable {
    var nextEatery: PlannerNextEatery?
    var nextActivity: PlannerNextActivity?
    var upComingEntertainments: [PlannerUpcomingEntertainment]?

    struct PlannerNextEatery: Codable {
        var name: String?
        var time: String?
    }
    
    struct PlannerNextActivity: Codable {
        var appointmentId: String?
        var bookableType: String?
        var imageUrl: String?
        var timePeriod: String?
        var title: String?
        var location: String?
        var inventoryState: String?
    }
    
    struct PlannerUpcomingEntertainment: Codable {
        var id: String?
        var title: String?
        var timePeriod: String?
        var location: String?
    }
}

extension GetHomePlannerResponse {
    static func mock() -> GetHomePlannerResponse {
        return GetHomePlannerResponse(
            nextEatery: PlannerNextEatery(
                name: "Razzle Dazzle at 8pm",
                time: "5:45pm"
            ),
            nextActivity: PlannerNextActivity(
                appointmentId: "activity456",
                bookableType: "ShoreExcursion",
                imageUrl: "https://example.com/activity.jpg",
				timePeriod: "8pm",
                title: "Bahamas Beach",
                location: "An evening of jazz and cocktails",
                inventoryState: "NonPaidInventoried"
            ),
			upComingEntertainments: [
                PlannerUpcomingEntertainment(
                    id: "entertainment789",
                    title: "Comedy Show",
                    timePeriod: "9:30am-10am",
                    location: "The Red Room, Deck 6"
                ),
                PlannerUpcomingEntertainment(
                    id: "entertainment012",
                    title: "Magic Show",
                    timePeriod: "9:30am-10am",
                    location: "The Red Room, Deck 6"
                )
            ]
        )
    }
}

extension NetworkServiceProtocol {
    func getHomePlanner(reservationGuestId: String, reservationNumber: String, shipCode: String, voyageNumber: String) async throws -> GetHomePlannerResponse? {        
        let request = GetHomePlannerRequest(
            input: GetHomePlannerDataInput(
                reservationNumber: reservationNumber,
                reservationGuestId: reservationGuestId,
                shipCode: shipCode,
                voyageNumber: voyageNumber
            )
        )
        return try await self.requestV2(request, responseModel: GetHomePlannerResponse.self)
    }
}

//
//  GetBoardingPassRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import Foundation

// MARK: - GetBoardingPassRequest

struct GetBoardingPassRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: GetBoardingPassDataInput
    
    var path: String {
        return NetworkServiceEndpoint.getBoardingPass
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
            .init(name: "shipCode", value: input.shipCode)
        ]
    }
}

// MARK: - GetBoardingPassDataInput

struct GetBoardingPassDataInput {
    let reservationNumber: String
    let reservationGuestId: String
    let shipCode: String
}

// MARK: - GetBoardingPassResponse

struct GetBoardingPassResponse: Decodable {
    
    let boardingPass: [BoardingPassItem]?
    
    struct BoardingPassItem: Decodable {
        let shipName: String?
        let voyageName: String?
        let depart: String?
        let arrive: String?
        let sailor: String?
        let bookingRef: String?
        let arrivalTime: String?
        let cabinNumber: String?
        let embarkation: String?
        let portLocation: String?
        let sailTime: String?
        let cabin: String?
        let musterStation: String?
        let notes: String?
        let imageUrl: String?
        let sailorTitle: String?
        let reservationGuestId: String?
        let firstName: String?
        let lastName: String?
        let coordinates: String?
        let placeId: String?
        let sailorType: String?
    }
    
}

// MARK: - NetworkServiceProtocol

extension NetworkServiceProtocol {
    
    func getBoardingPassContent(reservationNumber: String, reservationGuestId: String, shipCode: String) async throws -> GetBoardingPassResponse? {
        
        let request = GetBoardingPassRequest(input: GetBoardingPassDataInput(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId, shipCode: shipCode))
        
        return try await self.requestV2(request, responseModel: GetBoardingPassResponse.self)
    }
    
}

// MARK: - Mock Response

extension GetBoardingPassResponse {
    
    static func mock() -> GetBoardingPassResponse {
        
        return GetBoardingPassResponse(boardingPass: [
            
            BoardingPassItem(shipName: "Valiant Lady",
                             voyageName: "The Irresistible Med",
                             depart: "Jun 1",
                             arrive: "Jun 5",
                             sailor: "Samuel Hails",
                             bookingRef: "252877",
                             arrivalTime: "3:00pm",
                             cabinNumber: "12158A",
                             embarkation: "Sailor",
                             portLocation: "Port of Miami",
                             sailTime: "Departs at 6:00pm, local time. Sailors must be embarked 60 minutes prior.",
                             cabin: "Sea Terrace",
                             musterStation: "The Manor, Deck 6 Aft",
                             notes: "Wheelchair service, [Additional field], [Additional field], [Additional field]",
                             imageUrl: nil,
                             sailorTitle: nil,
                             reservationGuestId: "123455",
                             firstName: "John",
                             lastName: "Smith",
                             coordinates: "25.78011907532392, -80.1798794875817",
                             placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                             sailorType: "Standard"),
            
            BoardingPassItem(shipName: "Valiant Lady",
                             voyageName: "The Irresistible Med",
                             depart: "Jun 1",
                             arrive: "Jun 5",
                             sailor: "Anna Hails",
                             bookingRef: "252877",
                             arrivalTime: "3:00pm",
                             cabinNumber: "12158A",
                             embarkation: "Sailor",
                             portLocation: "Port of Miami",
                             sailTime: "Departs at 6:00pm, local time. Sailors must be embarked 60 minutes prior.",
                             cabin: "Sea Terrace",
                             musterStation: "The Manor, Deck 6 Aft",
                             notes: "Wheelchair service, [Additional field], [Additional field], [Additional field]",
                             imageUrl: nil,
                             sailorTitle: nil,
                             reservationGuestId: "123455",
                             firstName: "Anna",
                             lastName: "Smith",
                             coordinates: "25.78011907532392, -80.1798794875817",
                             placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                             sailorType: "Priority"),
            
            BoardingPassItem(shipName: "Valiant Lady",
                             voyageName: "The Irresistible Med",
                             depart: "Jun 1",
                             arrive: "Jun 5",
                             sailor: "Anna Hails",
                             bookingRef: "252877",
                             arrivalTime: "3:00pm",
                             cabinNumber: "12158A",
                             embarkation: "Sailor",
                             portLocation: "Port of Miami",
                             sailTime: "Departs at 6:00pm, local time. Sailors must be embarked 60 minutes prior.",
                             cabin: "Sea Terrace",
                             musterStation: "The Manor, Deck 6 Aft",
                             notes: "Wheelchair service, [Additional field], [Additional field], [Additional field]",
                             imageUrl: nil,
                             sailorTitle: nil,
                             reservationGuestId: "123455",
                             firstName: "Mia",
                             lastName: "Smith",
                             coordinates: "25.78011907532392, -80.1798794875817",
                             placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                             sailorType: "RockStar")
            
        ])
    }
    
}

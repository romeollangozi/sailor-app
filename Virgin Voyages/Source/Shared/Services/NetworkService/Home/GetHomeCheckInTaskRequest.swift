//
//  GetHomeCheckInTaskRequest.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import Foundation

struct GetHomeCheckInTaskRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetHomeCheckInTaskDataInput
    
    var path: String {
        return NetworkServiceEndpoint.getHomeCheckInTask
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
            .init(name: "reservationGuestId", value: input.reservationGuestId)
        ]
    }
}

struct GetHomeCheckInTaskDataInput {
    let reservationNumber: String
    let reservationGuestId: String
}


struct GetHomeCheckInTaskResponse: Codable {
    
    let rts: ReadyToSail?
    let embarkation: Embarkation?
    let healthCheck: HealthCheck?
    let serviceGratuities: ServiceGratuities?
    
    struct ReadyToSail: Codable {
        var id: String?
        var title: String?
        let imageUrl: String?
        let description: String?
        let status: String?
        let buttonLabel: String?
        let paymentNavigationUrl: String?
        let cabinMate: CabinMate?
    }
    
    struct CabinMate: Codable {
        let imageUrl: String?
        let title: String?
        let description: String?
    }
    
    struct Embarkation: Codable {
        let imageUrl: String?
        let title: String?
        let description: String?
        let status: String?
        let details: Details?
        let guide: Guide?
        
        struct Details: Codable {
            let sailorType: String?
            let title: String?
            let imageUrl: String?
            let arrivalSlot: String?
            let location: String?
            let coordinates: String?
            let placeId: String?
            let cabinType: String?
            let cabinDetails: String?
        }
        
        struct Guide: Codable {
            let title: String?
            let description: String?
            let navigationUrl: String?
        }
    }
    
    struct HealthCheck: Codable {
        let imageUrl: String?
        let title: String?
        let description: String?
        let status: String?
    }
    
    struct ServiceGratuities: Codable {
        let title: String?
        let description: String?
        let imageUrl: String?
        let status: String?
    }
}

extension GetHomeCheckInTaskResponse {
    
    static func mockResponse() -> GetHomeCheckInTaskResponse {
        .init(
            rts: ReadyToSail(
                title: "Check in and get Ready to Sail",
                imageUrl: "https://images.ctfassets.net/rxqefefl3t5b/2tzVzvSXr2O1DZGtRxgARU/404fb528344d0293d3c4c46e87dcdd89/CROP-IMG-SHP-scarlet-lady-exterior-v1-FIL_CF003118_Edited_V2-11517x8640.jpg?fl=progressive&q=80",
                description: "Complete your travel summary.",
                status: "inCompleted",
                buttonLabel: "Complete Now",
                paymentNavigationUrl: "https://example.com/payment",
                cabinMate: CabinMate(
                    imageUrl: "https://styles.redditmedia.com/t5_w3ufp/styles/communityIcon_1uav38k95crc1.jpg?format=pjpg&s=28b0137757b8303d59d756692cf5748fd6fa8d34",
                    title: "Cabin Mate Details",
                    description: "Your cabin mate has been assigned.")
            ),
            embarkation: Embarkation(imageUrl: "https://example.com/embarkation.jpg",
                                     title: "Embarkation Details test",
                                     description: "Get ready for a smooth embarkation process test.",
                                     status: "InCompleted",
                                     details: Embarkation.Details(sailorType: "Standard",
                                                                  title: "Boarding Slot Confirmed",
                                                                  imageUrl: "https://example.com/sailor.jpg",
                                                                  arrivalSlot: "TBC",
                                                                  location: "Port Terminal 3",
                                                                  coordinates: "25.78011907532392, -80.1798794875817",
                                                                  placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                                                                  cabinType: "Balcony",
                                                                  cabinDetails: "Deck 7 | Room 7204"),
                                     guide: Embarkation.Guide(title: "Embarkation guide",
                                                              description: "More information on your voyage embarkation",
                                                              navigationUrl: "https://example.com")
                                    ),
            healthCheck: HealthCheck(imageUrl: "https://example.com/health-check.jpg",
                                     title: "Health Check",
                                     description: "Complete your health declaration before boarding.",
                                     status: "Opened"),
            serviceGratuities: ServiceGratuities(title: "Pre-Pay Service Gratuities",
                                                description: "Service Gratuities are $20 per Sailor per day if paid prior to embarkation.",
                                                imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:94488f65-d736-4539-a294-aa43f43300e5/Icon-VoyageFair-Gratuities-128x128.svg",
                                                status: "Opened")
        )
    }
}


extension NetworkServiceProtocol {
    func getHomeCheckIn(reservationNumber: String, reservationGuestId: String) async throws -> GetHomeCheckInTaskResponse? {
        
        let request = GetHomeCheckInTaskRequest(
            input: GetHomeCheckInTaskDataInput(
                reservationNumber: reservationNumber,
                reservationGuestId: reservationGuestId
            )
        )
        
        return try await self.requestV2(request, responseModel: GetHomeCheckInTaskResponse.self)
    }
}

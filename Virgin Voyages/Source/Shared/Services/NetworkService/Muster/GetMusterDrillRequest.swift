//
//  GetMusterDrillRequest.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

struct GetMusterDrillRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetMusterDrillRequestInput
    
    var path: String {
        return NetworkServiceEndpoint.getMusterDrill
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "shipCode", value: input.shipcode),
            .init(name: "reservationGuestId", value: input.reservationGuestId),
            .init(name: "language", value: input.language),
            .init(name: "device", value: input.reservationGuestId)
        ]
    }
}

struct GetMusterDrillRequestInput {
    let shipcode: String
    let reservationGuestId: String
    let language: String = "eng"
    let device: String = "app"
}


struct GetMusterDrillResponse: Decodable {
    let assemblyStation: AssemblyStation?
    let mode: String?
    let video: VideoContent?
    let message: MessageContent?
    let languages: [Language]?
    let emergency: EmergencyContent?

    struct AssemblyStation: Codable {
        let station: String?
        let place: String?
        let deck: String?
    }

    struct VideoContent: Codable {
        let url: String?
        let title: String?
        let guest: GuestContent?
        let stillImageUrl: String?
    }

    struct GuestContent: Codable {
        let photoUrl: String?
        let name: String?
        let status: Bool?
    }

    struct MessageContent: Codable {
        let title: String?
        let description: String?
    }

    struct EmergencyContent: Codable {
        let title: String?
        let description: String?
    }

    struct Language: Codable {
        let id: String?
        let name: String?
        let localName: String?
    }

}

extension NetworkServiceProtocol {
    func getMusterDrillContent(shipcode: String, reservationGuestId: String) async throws -> GetMusterDrillResponse? {
        let request = GetMusterDrillRequest(
            input: GetMusterDrillRequestInput(
                shipcode: shipcode,
                reservationGuestId: reservationGuestId
            )
        )
        
        return try await self.requestV2(request, responseModel: GetMusterDrillResponse.self)
    }
}


extension GetMusterDrillResponse {
    static func mock() -> GetMusterDrillResponse {
        return GetMusterDrillResponse(
            assemblyStation: AssemblyStation(
                station: "E6",
                place: "The Roundabout",
                deck: "deck 6"
            ),
            mode: "Hidden",
            video: VideoContent(
                url: "https://www.sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4",
                title: "Watch this before the drill starts and then head to your assembly station",
                guest: GuestContent(
                    photoUrl: "https://application-cert.ship.virginvoyages.com/svc/dxpcore/mediaitems/7a577e7a-9c5e-46be-84fc-39a83be45d11",
                    name: "Courtney Johnson",
                    status: false
                ), stillImageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:108e0bb1-a3eb-4ba4-bcb6-9b1d5056f8b6/IMG-WEL-Safety-v2-311x175.png"
            ),
            message: MessageContent(
                title: "Message from the bridge",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            ),
            languages: [
                Language(id: "en", name: "English", localName: "English"),
                Language(id: "es", name: "Spanish", localName: "Español")
            ],
            emergency: EmergencyContent(
                title: "Your attention",
                description: "Go to your cabin if safe and collect your life jackets, warm clothing and essential medication, and proceed to your Assembly Station."
            )
        )
    }
}

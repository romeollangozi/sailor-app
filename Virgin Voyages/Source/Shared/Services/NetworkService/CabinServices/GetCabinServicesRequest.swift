//
//  GetCabinServicesRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/22/25.
//

import Foundation

struct GetCabinServicesRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: GetCabinServicesDataInput
    
    var path: String {
        return NetworkServiceEndpoint.cabinServices
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "cabinNumber", value: input.cabinNumber),
            .init(name: "shipcode", value: input.shipCode)
        ]
    }
}

struct GetCabinServicesDataInput {
    let cabinNumber: String
    let shipCode: String
}

struct GetCabinServicesResponse: Decodable {
    
    let items: [CabinServiceItem]?
    let title: String?
    let subTitle: String?
    let backgroundImageURL: String?
    let leadTime: LeadTime?
    
    struct CabinServiceItem: Decodable {
        let id: String?
        let name: String?
        let status: String?
        let requestId: String?
        let imageUrl: String?
        let designStyle: String?
        let options: [OptionItem]?
        let optionsTitle: String?
        let optionsDescription: String?
        let confirmationCta: String?
        let confirmationTitle: String?
        let confirmationDescription: String?
        
        struct OptionItem: Decodable {
            let id: String?
            let name: String?
            let icon: String?
            let status: String?
            let requestId: String?
        }
    }
    
    struct LeadTime: Decodable {
        let title: String?
        let imageUrl: String?
        let description: String?
    }
    
}

// MARK: - NetworkServiceProtocol

extension NetworkServiceProtocol {
    
    func getCabinServiceContent(cabinNumber: String,
                                shipCode: String) async throws -> GetCabinServicesResponse? {
        
        let request = GetCabinServicesRequest(input: GetCabinServicesDataInput(cabinNumber: cabinNumber,
                                                                               shipCode: shipCode))
        
        return try await self.requestV2(request, responseModel: GetCabinServicesResponse.self)
    }
}


// MARK: - Mock Response

extension GetCabinServicesResponse {
    
    static func mock() -> GetCabinServicesResponse {
        
        let cabinServiceItems = [GetCabinServicesResponse.CabinServiceItem(id: "freshTowels",
                                                                           name: "Fresh Towels",
                                                                           status: "Default",
                                                                           requestId: "185e8d03-8bbd-47fd-9ed8-c2fb7f455a6e",
                                                                           imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:46f24f04-5e00-4cf3-ad04-d2fa2264e019/C4D-Sailor-App-Services-Towels-800x1280.jpg",
                                                                           designStyle: "Normal",
                                                                           options: [CabinServiceItem.OptionItem(id: "bathTowelsReq",
                                                                                                                 name: "Bath towels",
                                                                                                                 icon: "",
                                                                                                                 status: "",
                                                                                                                 requestId: ""),
                                                                                     CabinServiceItem.OptionItem(id: "fullSetReq",
                                                                                                                 name: "Bath towels",
                                                                                                                 icon: "",
                                                                                                                 status: "",
                                                                                                                 requestId: "")
                                                                           ],
                                                                           optionsTitle: "Fresh towels",
                                                                           optionsDescription: "You have choices",
                                                                           confirmationCta: "Thanks",
                                                                           confirmationTitle: "Fresh towels are on their way.",
                                                                           confirmationDescription: "Sit back, shake for champagne, or just wait patiently at the door if you prefer."),
                                 GetCabinServicesResponse.CabinServiceItem(id: "cabinClean",
                                                                           name: "Cabin cleaned",
                                                                           status: "Default",
                                                                           requestId: "a2030fb1-7fbc-4348-adcb-b487ebd65c55",
                                                                           imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:c119b166-40dd-4859-b930-22a1f24c0534/C4D-Sailor-App-Services-Cabin-Cleanning-800x1280.jpg",
                                                                           designStyle: "Normal",
                                                                           options: [GetCabinServicesResponse.CabinServiceItem.OptionItem(id: "fullClean",
                                                                                                                                          name: "Full clean",
                                                                                                                                          icon: "",
                                                                                                                                          status: "",
                                                                                                                                          requestId: ""),
                                                                                     GetCabinServicesResponse.CabinServiceItem.OptionItem(id: "spillCleanUp",
                                                                                                                                          name: "Spill cleanup",
                                                                                                                                          icon: "",
                                                                                                                                          status: "",
                                                                                                                                          requestId: "")
                                                                           ],
                                                                           optionsTitle: "Cabin in need of a touch-up?",
                                                                           optionsDescription: "We can send someone to clean your cabin right away.",
                                                                           confirmationCta: "Thanks",
                                                                           confirmationTitle: "We're on our way.",
                                                                           confirmationDescription: "Someone from our Crew will be there shortly to help clean your space right up.")
        ]
        
        let mock =  GetCabinServicesResponse(items: cabinServiceItems,
                                             title: "Hey Sailor, tell us how we can help you.",
                                             subTitle: "Cabin Services",
                                             backgroundImageURL: "https://cms-cert.ship.virginvoyages.com/dam/jcr:24afc9f5-9271-40c4-b233-3c804060c1ac/C4D-Sailor-App-Services-Landing-800x1280.jpg",
                                             leadTime: GetCabinServicesResponse.LeadTime(title: "Making your cabin...",
                                                                                         imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:0079cb42-cb31-4677-985c-1d401e2f206d/Cabin_Services_464x464.jpg",
                                                                                         description: "Once you're on board, come back here for all your cabin wants and needs.")
        )
        
        return mock
    }
}

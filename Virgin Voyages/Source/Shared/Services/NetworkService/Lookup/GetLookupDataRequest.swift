//
//  GetLookupDataRequest.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 13.3.25.
//

import Foundation

struct GetLookupDataRequest: AuthenticatedHTTPRequestProtocol {
    var path: String {
        return "/rts-bff/lookup"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetLookupDataResponse: Codable {
    let referenceData: LookupData?
    
    struct LookupData: Codable {
        let airlines: [Airline]?
        let airports: [Airport]?
        let cardTypes: [CardType]?
        let cities: [City]?
        let countries: [Country]?
        let documentTypes: [DocumentType]?
        let genders: [Gender]?
        let languages: [Language]?
        let paymentModes: [PaymentMode]?
        let ports: [Port]?
        let rejectionReasons: [RejectionReason]?
        let relations: [Relation]?
        let states: [State]?
        let visaEntries: [VisaEntry]?
        let visaTypes: [VisaType]?
        let postCruiseAddressTypes: [PostCruiseAddressType]?
        let postCruiseTransportationOptions: [PostCruiseTransportationOption]?
        let documentCategories: [DocumentCategory]?
        
        struct Airline: Codable {
            let code: String?
            let name: String?
        }
        
        struct Airport: Codable {
            let name: String?
            let code: String?
            let cityId: String?
            let cityName: String?
        }
        
        struct CardType: Codable {
            let referenceId: String?
            let name: String?
            let image: Image?
            
            struct Image: Codable {
                let src: String?
                let alt: String?
            }
        }
        
        struct City: Codable {
            let name: String?
            let id: String?
            let countryCode: String?
        }
        
        struct Country: Codable {
            let name: String?
            let code: String?
            let threeLetterCode: String?
            let dialingCode: String?
        }
        
        struct DocumentType: Codable {
            let code: String?
            let name: String?
        }
        
        struct Gender: Codable {
            let name: String?
            let code: String?
        }
        
        struct Language: Codable {
            let code: String?
            let name: String?
        }
        
        struct PaymentMode: Codable {
            let id: String?
            let name: String?
        }
        
        struct Port: Codable {
            let code: String?
            let name: String?
            let countryCode: String?
        }
        
        struct RejectionReason: Codable {
            let rejectionReasonId: String?
            let name: String?
        }
        
        struct Relation: Codable {
            let code: String?
            let name: String?
        }
        
        struct State: Codable {
            let code: String?
            let countryCode: String?
            let name: String?
        }
        
        struct VisaEntry: Codable {
            let code: String?
            let name: String?
        }
        
        struct VisaType: Codable {
            let code: String?
            let name: String?
            let countryCode: String?
        }
        
        struct PostCruiseAddressType: Codable {
            let name: String?
            let code: String?
        }
        
        struct PostCruiseTransportationOption: Codable {
            let name: String?
            let code: String?
        }
        
        struct DocumentCategory: Codable {
            let id: String?
            let code: String?
            let name: String?
            let typeCode: String?
        }
    }
}

extension NetworkServiceProtocol {
	func getLookupData(cacheOption: CacheOption) async throws -> GetLookupDataResponse? {
        let request = GetLookupDataRequest()
		return try await self.requestV2(request, responseModel: GetLookupDataResponse.self, cacheOption: cacheOption)
    }
}

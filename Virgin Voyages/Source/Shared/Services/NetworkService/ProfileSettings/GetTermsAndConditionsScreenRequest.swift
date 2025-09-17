//
//  GetTermsAndConditionsScreen.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import Foundation


struct GetTermsAndConditionsScreenRequest: AuthenticatedHTTPRequestProtocol {

    var shipCode: String

    var path: String {
        return NetworkServiceEndpoint.getSettingsProfileTermsAndConditionsScreen
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    init(shipCode: String) {
        self.shipCode = shipCode
    }

    
    var queryItems: [URLQueryItem]? {
        let shipCode: URLQueryItem = .init(name: "shipCode", value: shipCode)
        return [shipCode]
    }
}

struct GetTermsAndConditionsScreenResponse: Decodable {
    let heading: String?
    let general: GetTermsAndConditionsDetailsResponse?
    let mobile: GetTermsAndConditionsDetailsResponse?
    let privacy: GetTermsAndConditionsDetailsResponse?
    let cookie: GetTermsAndConditionsDetailsResponse?

    struct GetTermsAndConditionsDetailsResponse: Decodable {
        let heading: String?
        let content: [GetTermsAndConditionsDetailsContentResponse]
    }

    struct GetTermsAndConditionsDetailsContentResponse: Decodable {
        let title: String?
        let subtitle: String?
        let body: String?
    }
}

extension NetworkServiceProtocol {
    
    func fetchSettingsTermsAndConditionsScreen(shipCode: String) async -> ApiResponse<GetTermsAndConditionsScreenResponse> {
        let request = GetTermsAndConditionsScreenRequest(shipCode: shipCode)
        return await self.request(request, responseModel: GetTermsAndConditionsScreenResponse.self)
    }
}

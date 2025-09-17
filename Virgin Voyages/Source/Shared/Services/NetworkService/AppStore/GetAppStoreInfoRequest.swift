//
//  GetAppStoreInfoRequest.swift
//  Virgin Voyages
//
//  Created by TX on 23.5.25.
//

import Foundation

struct GetAppStoreInfoRequest: AuthenticatedHTTPRequestProtocol {

    var path: String {
        return "NetworkServiceEndpoint.getAppStoreInfo"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            // TODO: Add params if needed
        ]
    }
}

struct GetAppStoreInfoResponse: Decodable {
    let hasUpdate: Bool?
    let appVersion: String?
}

extension NetworkServiceProtocol {
    func getAppStoreInfo() async throws -> GetAppStoreInfoResponse? {
        let request = GetAppStoreInfoRequest()
        return try await self.requestV2(request, responseModel: GetAppStoreInfoResponse.self)
    }
}

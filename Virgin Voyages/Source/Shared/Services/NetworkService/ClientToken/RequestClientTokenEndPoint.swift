//
//  RequestClientTokenEndPoint.swift
//  Virgin Voyages
//
//  Created by TX on 8.8.25.
//

import Foundation

enum RequestClientTokenEndPoint {
    case clientToken
}

extension RequestClientTokenEndPoint: HTTPRequestProtocol {

    // MARK: - Path
    var path: String {
        switch self {
        case .clientToken:
            return NetworkServiceEndpoint.clientTokenPath
        }
    }

    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .clientToken:
            return .POST
        }
    }

    // MARK: - Headers
    var headers: HTTPHeadersProtocol? {
        switch self {
        case .clientToken:
            let endpoint = Endpoint.BasicAuthentication(host: AuthenticationService.shared.host())
            return HTTPHeaders([
                "Content-Type": "application/json;charset=utf-8",
                "Accept": "application/json",
                "authorization": endpoint.authorizationHeader
            ])
        }
    }

    // MARK: - Body (dictionary)
    var body: [String : Any]? {
        switch self {
        case .clientToken:
            return [:]
        }
    }

    // MARK: - Body (raw data)
    var bodyData: Data? {
        switch self {
        case .clientToken:
            // No raw body required; queryItems carries grant_type
            return nil
        }
    }

    // MARK: - Query parameters
    var queryItems: [URLQueryItem]? {
        switch self {
        case .clientToken:
            return [URLQueryItem(name: "grant_type", value: "client_credentials")]
        }
    }
}

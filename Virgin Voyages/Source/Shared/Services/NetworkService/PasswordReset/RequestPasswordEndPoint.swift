//
//  RequestPasswordEndPoint.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation

// MARK: - RequestPasswordEndPoint
enum RequestPasswordEndPoint {
    case resetPassword(clientToken: String, email: String, reCaptcha: String)
}

extension RequestPasswordEndPoint: HTTPRequestProtocol {

    // MARK: - Path
    var path: String {
        switch self {
        case .resetPassword:
            return NetworkServiceEndpoint.resetPasswordPath
        }
    }

    // MARK: - Method
    var method: HTTPMethod {
        switch self {
        case .resetPassword:
            return .POST
        }
    }

    // MARK: - Headers
    var headers: HTTPHeadersProtocol? {
        switch self {
        case .resetPassword(let token, _, let reCaptcha):
            return HTTPHeaders(["Content-Type": "application/json;charset=utf-8",
                                "Accept": "application/json",
                                "authorization" : "bearer \(token)",
                                "VV-ReCaptchaToken": reCaptcha,
                                "VV-UserAgent": "ios"
                               ])
        }
    }

    // MARK: - Body (dictionary)
    var body: [String : Any]? {
        switch self {
        case .resetPassword(_, let email, _):
            return ["email": email]
        }
    }

    // MARK: - Body (raw data)
    var bodyData: Data? {
        switch self {
        case .resetPassword(_, let email, _):
            do {
                return try JSONEncoder().encode(["email": email])
            } catch {
                return nil
            }
        }
    }

    // MARK: - Query parameters
    var queryItems: [URLQueryItem]? {
        switch self {
        case .resetPassword:
            return []
        }
    }
}


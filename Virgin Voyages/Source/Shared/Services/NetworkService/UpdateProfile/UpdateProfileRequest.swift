//
//  UpdateProfileRequest.swift
//  Virgin Voyages
//
//  Created by TX on 27.1.25.
//

import Foundation

//NOTE: - This request should be usedwhenever users want to update a field on their profile.

struct UpdateProfileRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: UpdateProfileRequestBody

    var path: String = NetworkServiceEndpoint.updateUserProfile

    var method: HTTPMethod {
        return .PUT
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var body: [String : Any]? {
        return [input.key.stringValue : input.value, "action" : input.action.stringValue]
    }
}

extension UpdateProfileRequest {
    enum ProfileUpdateValueKey: Codable {
        case photoUrl
        
        var stringValue: String {
            switch self {
            case .photoUrl:
                return "photoUrl"
            }
        }
    }
    
    enum ProfileUpdateActionType: Codable {
        case setUserProfile
        
        var stringValue: String {
            switch self {
            case .setUserProfile:
                return "setUserProfile"
            }
        }
    }
}

struct UpdateProfileRequestBody: Codable {
    let key: UpdateProfileRequest.ProfileUpdateValueKey
    let value: String
    let action: UpdateProfileRequest.ProfileUpdateActionType
}

extension NetworkServiceProtocol {
    func updateProfileData(input: UpdateProfileRequestBody) async throws -> EmptyResponse {
        let request = UpdateProfileRequest(input: input)
        return try await self.requestV2(request, responseModel: EmptyResponse.self)
    }
}



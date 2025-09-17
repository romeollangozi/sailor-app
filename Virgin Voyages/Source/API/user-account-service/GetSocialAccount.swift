//
//  SocialMediaAccount.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/16/23.
//

import Foundation

extension Endpoint {
	struct GetSocialAccount: Requestable {
		typealias RequestType = Request
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .basic
		var path = "/user-account-service/signin/social"
		var method: Method = .post
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .any
		var pathComponent: String?
		var request: Request?
		var query: Query?
		
        init(appleId: String, type: SocialMediaType = .apple) {
            request = .init(socialMediaId: appleId)
            query = .init(type: type)
		}
		
		struct Query: Encodable {
			var type: SocialMediaType // "apple"
		}
		
		struct Request: Encodable {
            var email: String?
            var socialMediaId: String
            var birthDate: String?
            var lastName: String?
            var firstName: String?
            var preferredName: String?
            var userType: String?
            var enableEmailNewsOffer: Bool?
            var isVerificationRequired: Bool?
		}
		
		struct Response: Codable {
			var userType: String // "guest"
			var refreshToken: String? // ""
			var tokenType: String // "bearer"
			var accessToken: String // ""
			var expiresIn: Int // 2591999
			var status: AccountStatusDTO
		}

        enum SocialMediaType: String, Encodable {
            case apple
            case google
            case facebook
        }
	}
}

//
//  GetLogout.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 3/14/24.
//

import Foundation

extension Endpoint {
	struct GetLogout: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/user-account-service/logout"
		var method: Method = .post
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .any
		var pathComponent: String?
		var request: NoRequest?
		var query: NoQuery?

		struct Response: Decodable {

		}
	}
}

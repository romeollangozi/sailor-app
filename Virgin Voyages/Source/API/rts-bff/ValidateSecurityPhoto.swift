//
//  UploadSecurityPhoto.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/29/24.
//

import Foundation

extension Endpoint {
	struct ValidateSecurityPhoto: Requestable {
		typealias RequestType = Request
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/photo/security/validate"
		var method: Method = .post
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: Request?
		var query: NoQuery?
		
		init(data: Data) {
			request = .init(photoContent: data.base64EncodedString())
		}

		struct Request: Encodable {
			var photoContent: String // {Base64 content}
		}
		
		struct Response: Codable {
			var isValidPhoto: Bool // false
			var rejectionReasonIds: [String] // ["9c3f3987-00bc-456d-a443-6edea13d2696"]
		}
	}
}

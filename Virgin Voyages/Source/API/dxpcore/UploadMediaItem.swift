//
//  GetMediaItems.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/3/24.
//

import Foundation

extension Endpoint {
	struct UploadMediaItem: Uploadable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/dxpcore/mediaitems"
		var method: Method = .form
		var cachePolicy: CachePolicy = .none
		var scope: RequestScope = .any
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		var formData: Data
		var mimeType: MimeType

		init(imageData: Data, imageType: ImageType) {
			let mediaGroupId = "f67c581d-4a9b-e611-80c2-00155df80332"
			self.query = .init(mediagroupid: mediaGroupId)
			self.formData = imageData
			self.mimeType = imageType.mimeType
		}
		
		struct Query: Encodable {
			var mediagroupid: String
		}
		
		struct Response: Decodable {

		}
	}
}

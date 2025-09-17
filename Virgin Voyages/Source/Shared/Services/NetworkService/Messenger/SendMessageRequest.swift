//
//  SendMessageRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 19.2.25.
//
import Foundation

struct SendMessageRequest: FormDataHTTPRequestProtocol {

	let queueId: String,
		voyageNumber: String,
		content: String

	var parameters: [String: String] {
		["queue_id": queueId,
		"voyage_number": voyageNumber,
		"content": content]
	}

	var path: String {
		return NetworkServiceEndpoint.sendChatMessage
	}

	var method: HTTPMethod {
		return .POST
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
}

struct SendMessageResponse: Decodable {
	let id: Int?
	let result: String?
	let msg: String?
	let varName: String?
	let code: String?

	enum CodingKeys: String, CodingKey {
		case id
		case result
		case msg
		case varName = "var_name"
		case code
	}
}

extension NetworkServiceProtocol {
	func sendMessage(queueId: String, voyageNumber: String, content: String) async throws -> SendMessageResponse? {
		let request = SendMessageRequest(queueId: queueId, voyageNumber: voyageNumber, content: content)
		return try await self.requestV2(request, responseModel: SendMessageResponse.self)
	}
}

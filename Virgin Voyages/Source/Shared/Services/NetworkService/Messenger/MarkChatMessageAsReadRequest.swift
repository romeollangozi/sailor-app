//
//  MarkChatMessageAsReadRequest 2.swift
//  Virgin Voyages
//
//  Created by TX on 19.5.25.
//
import Foundation

struct MarkChatMessageAsReadRequest: URLEncodedRequestProtocol {
    
    let input: MarkChatMessageAsReadRequestInput
   
    var path: String = NetworkServiceEndpoint.markSupportChatMessageAsRead

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var parameters: [String: Any] {
        ["op": input.op,
         "flag": input.flag,
         "messages": input.messages,
         "queue_id": input.queue_id]
    }
}

struct MarkChatMessageAsReadRequestInput: Codable {
    let op: String // add
    let flag: String // delivered
    let messages: [Int] // [9447, 9448]
    let queue_id: String // 1303
    
    init(op: String, flag: String, messages: [Int], queue_id: String) {
        self.op = op
        self.flag = flag
        self.messages = messages
        self.queue_id = queue_id
    }
}

struct MarkChatMessageAsReadResponse: Decodable {}

extension NetworkServiceProtocol {
	func markChatMessagesAsRead(input: MarkChatMessageAsReadRequestInput) async throws -> MarkChatMessageAsReadResponse? {
        let request = MarkChatMessageAsReadRequest(input: input)
		return try await self.requestV2(request, responseModel: MarkChatMessageAsReadResponse.self)
	}
}

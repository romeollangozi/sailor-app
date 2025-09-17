//
//  MarkCrewChatMessageAsReadRequest.swift
//  Virgin Voyages
//
//  Created by TX on 19.5.25.
//

import Foundation

struct MarkCrewChatMessageAsReadRequest: URLEncodedRequestProtocol {
    
    let input: MarkCrewChatMessageAsReadRequestInput
   
    var path: String = NetworkServiceEndpoint.markCrewChatMessageAsRead

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var parameters: [String: Any] {
        ["op": input.op,
         "flag": input.flag,
         "messages": input.messages]
    }
}

struct MarkCrewChatMessageAsReadRequestInput: Codable {
    let op: String // add
    let flag: String // delivered
    let messages: [Int] // [9447, 9448]
    
    init(op: String, flag: String, messages: [Int]) {
        self.op = op
        self.flag = flag
        self.messages = messages
    }
}

struct MarkCrewChatMessageAsReadResponse: Decodable {}

extension NetworkServiceProtocol {
    func markCrewChatMessagesAsRead(input: MarkCrewChatMessageAsReadRequestInput) async throws -> MarkCrewChatMessageAsReadResponse? {
        let request = MarkCrewChatMessageAsReadRequest(input: input)
        return try await self.requestV2(request, responseModel: MarkCrewChatMessageAsReadResponse.self)
    }
}

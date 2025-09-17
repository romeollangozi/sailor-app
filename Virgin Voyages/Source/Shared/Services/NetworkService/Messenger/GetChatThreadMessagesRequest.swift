//
//  GetChatThreadMessages.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.2.25.
//

import Foundation

struct GetChatThreadMessagesRequest: AuthenticatedHTTPRequestProtocol {
    let threadId: String
    let voyageNumber: String
    let sailorId: String
    let pageSize: Int
    let anchor: Int?
    let type: String
   
    var path: String {
        return NetworkServiceEndpoint.getChatThreadMessages + "/\(threadId)/messages"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let voyageNumber: URLQueryItem = .init(name: "voyageNumber", value: self.voyageNumber)
        let sailorId: URLQueryItem = .init(name: "sailorId", value: self.sailorId)
        let pageSize: URLQueryItem = .init(name: "pageSize", value: "\(self.pageSize)")
        let type: URLQueryItem = .init(name: "type", value: "\(self.type)")

        switch anchor == nil {
        case true:
            return [voyageNumber, sailorId, pageSize, type]
        case false:
            let anchor: URLQueryItem = .init(name: "anchor", value: "\(self.anchor.value)")
            return [voyageNumber, sailorId, pageSize, type, anchor]
        }
    }
}


struct GetChatThreadMessagesResponse: Decodable {
    let items: [ChatItem]?
    let nextAnchor: Int?
    let hasMore: Bool?
    
    struct ChatItem: Decodable {
        let id: Int?
        let content: Content?
        let isMine: Bool?
        let type: String?
        let createdAt: String?

        enum CodingKeys: String, CodingKey {
            case id, content, isMine, type, createdAt
        }

        enum Content: Decodable {
            case string(String)
            case array([String])
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                
                if let stringValue = try? container.decode(String.self) {
                    self = .string(stringValue)
                } else if let arrayValue = try? container.decode([String].self) {
                    self = .array(arrayValue)
                } else {
                    throw DecodingError.typeMismatch(
                        Content.self,
                        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Content value is not a String or [String]")
                    )
                }
            }
        }
    }
}

extension NetworkServiceProtocol {
    func fetchChatThreadMessages(threadId: String,
                               voyageNumber: String,
                               sailorId: String,
                               pageSize: Int,
                               anchor: Int?,
                               type: String) async throws -> GetChatThreadMessagesResponse? {
        let request = GetChatThreadMessagesRequest(threadId: threadId,
                                                   voyageNumber: voyageNumber,
                                                   sailorId: sailorId,
                                                   pageSize: pageSize,
                                                   anchor: anchor,
                                                   type: type)
        return try await self.requestV2(request, responseModel: GetChatThreadMessagesResponse.self)
    }
}

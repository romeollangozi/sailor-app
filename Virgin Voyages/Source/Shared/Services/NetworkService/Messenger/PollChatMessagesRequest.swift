//
//  PollChatMessagesRequest.swift
//  Virgin Voyages
//
//  Created by TX on 20.2.25.
//

import Foundation

struct PollChatMessagesRequest: AuthenticatedHTTPRequestProtocol {
    
    let queueID: String
    let lastEventID: Int

    var path: String {
        NetworkServiceEndpoint.pollChatMessages
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        let queueID: URLQueryItem = .init(name: "queue_id", value: queueID)
        let lastEventID: URLQueryItem = .init(name: "last_event_id", value: "\(lastEventID)")
        
        return [queueID, lastEventID]
    }

    var timeout: TimeInterval {
        return 120 // 2 minutes timeout to exceed the response timeout
    }
}

struct PollChatMessagesResponse: Decodable {
    let result: String?
    let msg: String?
    let events: [Event]?
    let queue_id: String?

    struct Event: Codable {
        let type: String?
        let id: Int?
    }
}

extension NetworkServiceProtocol {
    func pollChatMessages(queueID: String, lastEventID: Int) async throws -> PollChatMessagesResponse? {
        let request = PollChatMessagesRequest(queueID: queueID, lastEventID: lastEventID)
        let response = try await self.requestV2(request, responseModel: PollChatMessagesResponse.self)
        print("pollChatMessages response: \(response)")
        return response
    }
}

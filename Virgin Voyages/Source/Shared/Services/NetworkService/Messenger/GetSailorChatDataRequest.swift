//
//  GetSailorChatDataRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

import Foundation

struct GetSailorChatDataRequest: AuthenticatedHTTPRequestProtocol {
    let voyageNumber: String
    
    var path: String {
        return NetworkServiceEndpoint.getSailorChatData
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "voyage_number", value: voyageNumber)]
    }
}

struct SailorChatDataResponse: Decodable {
    let result: String?
    let msg: String?
    let id: Int?
    let sailorIamUserId: String?
    let subject: String?
    let status: String?
    let loyalty: String?
    let cabinNumber: String?
    let ownedBy: String?
    let requiresAttention: Bool?
    let creationTime: Int?
    let firstMessageTime: Int?
    let streamId: Int?
    let voyageNumber: String?
    let resolvedAt: String?
    let lastMessageContent: String?
    let lastMessageTime: Int?
    let lastMessageSenderIamId: String?
    let lastMessageSenderTime: Int?
    let isUserAccountMerged: Bool?
	
	private enum CodingKeys: String, CodingKey {
		case lastMessageSenderIamId = "last_message_sender_iam_id"
		case isUserAccountMerged = "is_user_account_merged"
		case status
		case requiresAttention = "requires_attention"
		case firstMessageTime = "first_message_time"
		case sailorIamUserId = "sailor_iam_user_id"
		case streamId = "stream_id"
		case creationTime = "creation_time"
		case subject
		case loyalty
		case lastMessageTime = "last_message_time"
		case cabinNumber = "cabin_number"
		case id
		case voyageNumber = "voyage_number"
		case resolvedAt = "resolved_at"
		case ownedBy = "owned_by"
		case result
		case lastMessageSenderTime = "last_message_sender_time"
		case msg
		case lastMessageContent = "last_message_content"
	}
}

extension NetworkServiceProtocol {
    func getSailorChatData(voyageNumber: String) async throws -> SailorChatDataResponse? {
        let request = GetSailorChatDataRequest(voyageNumber: voyageNumber)
        return try await self.requestV2(request, responseModel: SailorChatDataResponse.self)
    }
}

//
//  SendCrewMessageRequest.swift
//  Virgin Voyages
//
//  Created by TX on 19.5.25.
//

import Foundation

struct SendCrewMessageRequest: FormDataHTTPRequestProtocol {

    let input: SendCrewMessageRequestInput
    
    var parameters: [String: String] {
        ["to": input.to,
         "voyage_number": input.voyageNumber,
         "content": input.content,
         "is_send_notification": input.is_send_notification,
         "type": input.type
        ]
    }

    var path: String {
        return NetworkServiceEndpoint.sendCrewChatMessage
    }

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct SendCrewMessageRequestInput: Encodable {
    let to: String,
        voyageNumber: String,
        content: String,
        is_send_notification: String,
        type: String
}

extension NetworkServiceProtocol {
    func sendCrewMessage(input: SendCrewMessageRequestInput) async throws -> SendMessageResponse? {
        let request = SendCrewMessageRequest(input: input)
        return try await self.requestV2(request, responseModel: SendMessageResponse.self)
    }
}

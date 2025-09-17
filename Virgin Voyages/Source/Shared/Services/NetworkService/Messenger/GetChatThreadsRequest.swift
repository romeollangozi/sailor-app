//
//  GetChatThreadsRequest.swift
//  Virgin Voyages
//
//  Created by TX on 13.2.25.
//

import Foundation

struct GetChatThreadsRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: ChatThreadRequestBody
    
    var path: String {
        return NetworkServiceEndpoint.getChatThreads
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let voyageNumber: URLQueryItem = .init(name: "voyageNumber", value: input.voyageNumber)
        let reservationGuestId: URLQueryItem = .init(name: "reservationGuestId", value: input.reservationGuestID)
        let sailorType: URLQueryItem = .init(name: "sailorType", value: input.sailorType)
        
        return [voyageNumber, sailorType, reservationGuestId]
    }

}

struct ChatThreadResponse: Decodable {
    
    let items: [ChatThread]
    
    struct ChatThread: Decodable {
        let id: String?
        let title: String?
        let unreadCount: Int?
        let isClosed: Bool?
        let type: ChatThreadResponse.ChatType?
        let description: String?
        let lastMessageTime: String?
        let imageURL: String?
    }
    
    enum ChatType: String, Decodable {
		case sailorServices = "SailorServices"
		case sailor = "Sailor"
		case rockStarAgent = "RockStarAgent"
        case crew = "Crew"
    }
}


struct ChatThreadRequestBody {
    let voyageNumber: String
    let sailorType: String
    let reservationGuestID: String
}


extension NetworkServiceProtocol {
    func fetchChatThreads(voyageNumber: String, sailorType: String, reservationGuestID: String) async throws -> ChatThreadResponse {
        let request = GetChatThreadsRequest(input: .init(voyageNumber: voyageNumber, sailorType: sailorType, reservationGuestID: reservationGuestID))
        return try await self.requestV2(request, responseModel: ChatThreadResponse.self)
    }
}


// MARK: - Mock Response
extension ChatThreadResponse {
    static let mock: ChatThreadResponse = ChatThreadResponse(
        items: [
            ChatThread(
                id: "101",
                title: "Sailor Services",
                unreadCount: 3,
                isClosed: false,
                type: .sailorServices,
                description: "Assistance with voyage-related inquiries.",
                lastMessageTime: "12pm",
                imageURL: "https://cdn.prod.website-files.com/62d84e447b4f9e7263d31e94/6399a4d27711a5ad2c9bf5cd_ben-sweet-2LowviVHZ-E-unsplash-1.jpeg"
            ),
            ChatThread(
                id: "103-ASD-123",
                title: "RockStar Agent Support",
                unreadCount: 5,
                isClosed: false,
                type: .rockStarAgent,
                description: "Exclusive chat with RockStar agent.",
                lastMessageTime: "12pm",
                imageURL: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?cs=srgb&dl=pexels-souvenirpixels-414612.jpg&fm=jpg"
            ),
            ChatThread(
                id: "102",
                title: "Chat with John Doe",
                unreadCount: 0,
                isClosed: false,
                type: .sailor,
                description: "Private chat with another sailor.",
                lastMessageTime: "12pm",
                imageURL: nil
            )
        ]
    )
}

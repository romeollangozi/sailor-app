//
//  RegisterForChatPollingRequest.swift
//  Virgin Voyages
//
//  Created by TX on 20.2.25.
//

import Foundation


struct RegisterForChatPollingRequest: AuthenticatedHTTPRequestProtocol {
    let input: RegisterForChatPollingBody
    
    var path: String {
        return NetworkServiceEndpoint.registerForChatPolling
    }
    
    var method: HTTPMethod {
        return .POST
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
        
    var bodyCodable: (any Codable)? {
        return input
    }
}

struct RegisterForChatPollingBody : Codable {
    
    var event_types: [String] = EventType.allValues // For now we always register for all types
    
    enum EventType: String, CaseIterable {
        case notifications = "Notifications"
        case statusBanners = "StatusBanners"
        case urlNotifications = "URLNotifications"
        case urlStatusBanners = "URLStatusBanners"
        case chatNotifications = "ChatNotifications"
        case reminderNotification = "ReminderNotification"
        case actionNotifications = "ActionNotifications"

        static var allValues: [String] {
            return allCases.map { $0.rawValue }
        }
    }
}

struct RegisterForChatPollingResponse: Decodable {
    let result: String?
    let msg: String?
    let queue_id: String?
    let last_event_id: Int?
}

extension NetworkServiceProtocol {
    func registerForPolling(input: RegisterForChatPollingBody) async throws -> RegisterForChatPollingResponse {
        let request = RegisterForChatPollingRequest(input: input)
        let response = try await self.requestV2(request, responseModel: RegisterForChatPollingResponse.self)
        print("registerForPolling response: \(response)")
        return response
    }
}

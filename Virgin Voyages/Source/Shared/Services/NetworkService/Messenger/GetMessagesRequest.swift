//
//  GetMessagesRequest.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 21.10.24.
//

import Foundation

enum GetMessagesRequest {
    case getUnreadMessages(pageNumber: Int, voyageNumber: String)
    case getReadMessages(pageNumber: Int, voyageNumber: String)
}

extension GetMessagesRequest: AuthenticatedHTTPRequestProtocol {
    
    var pageNumber: Int{
        switch self {
        case .getUnreadMessages(let page, let voyageNumber):
            page
        case .getReadMessages(let page, let voyageNumber):
            page
        }
    }
    
    var voyageNumber: String{
        switch self {
        case .getUnreadMessages(_, let voyageNumber):
            voyageNumber
        case .getReadMessages(_, let voyageNumber):
            voyageNumber
        }
    }
    
    var path: String {
        switch self {
        case .getUnreadMessages:
            return NetworkServiceEndpoint.getUnreadMessages
        case .getReadMessages:
            return NetworkServiceEndpoint.getReadMessages
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    var queryItems: [URLQueryItem]? {
        let pageNo: URLQueryItem = .init(name: "PageNo", value: "\(pageNumber)")
        let eventType: URLQueryItem = .init(name: "EventType", value: "Notifications, URLNotifications, ActionNotifications")
        let voyageNumber: URLQueryItem = .init(name: "voyageNumber", value: "\(voyageNumber)")
        
        return [pageNo, eventType, voyageNumber]
    }
}

struct GetMessagesRsponse: Decodable {
    var unreadNotification: [Notification]?
    var readNotification: [Notification]?

    var Length: Int? // 728
    
    struct Notification: Codable {
        var Notification_Body: String?
        var type: String?
        var NotificationID: String?
        var Notification_Title: String?
        var Read_Time: Double?
        var sentAt: Double?
        var userID: String?
        var Notification_Type: String?
        var Notification_Data: String?
    }
}


extension NetworkServiceProtocol {
    
    func fetchUnreadMessages(pageNumber: Int, voyageNumber:String) async -> ApiResponse<GetMessagesRsponse> {
        let request = GetMessagesRequest.getUnreadMessages(pageNumber: pageNumber, voyageNumber: voyageNumber)
        let result = await self.request(request, responseModel: GetMessagesRsponse.self)
        return result
    }
    
    func fetchReadMessages(pageNumber: Int, voyageNumber: String) async -> ApiResponse<GetMessagesRsponse> {
        let request = GetMessagesRequest.getReadMessages(pageNumber: pageNumber, voyageNumber: voyageNumber)
        let result = await self.request(request, responseModel: GetMessagesRsponse.self)
        return result
    }
}

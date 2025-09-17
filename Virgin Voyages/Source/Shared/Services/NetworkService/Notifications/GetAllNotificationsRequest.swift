//
//  GetAllNotificationsRequest.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 25.5.25.
//

import Foundation

struct GetAllNotificationsRequest: AuthenticatedHTTPRequestProtocol {
	let voyageNumber: String
	let page: Int
	
	var path: String {
		return NetworkServiceEndpoint.notifications
	}
	
	var method: HTTPMethod {
		return .GET
	}
	
	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}
	
	var queryItems: [URLQueryItem]? {
		return [URLQueryItem(name: "voyageNumber", value: self.voyageNumber),
				URLQueryItem(name: "page", value: "\(page)")]
	}
}

struct GetAllNotificationsResponse: Decodable {
	let items: [NotificationItem]?
	let hasMore: Bool?
	
	struct NotificationItem: Decodable {
		let id: String?
		let type: String?
		let data: String?
		let title: String?
		let description: String?
		let isRead: Bool?
		let createdAt: String?
        let isTappable: Bool?
        let isDismissable: Bool?
	}
}

extension NetworkServiceProtocol {
	func getNotifications(voyageNumber: String, page: Int) async throws -> GetAllNotificationsResponse? {
		let request = GetAllNotificationsRequest(voyageNumber:voyageNumber, page: page)
		
		return try await self.requestV2(request, responseModel: GetAllNotificationsResponse.self)
	}
}

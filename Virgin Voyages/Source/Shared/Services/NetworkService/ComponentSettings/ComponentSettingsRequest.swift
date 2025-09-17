//
//  ComponentSettingsRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 20.5.25.
//

import Foundation

struct ComponentSettingsRequest: AuthenticatedHTTPRequestProtocol {
    var path: String {
        return NetworkServiceEndpoint.componentSettings
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        guard let token = self.tokenManager.token?.accessToken else { return nil }
        return HTTPHeaders(["Authorization": "Bearer \(token)"])
    }

    var queryItems: [URLQueryItem]? {
        let componentId: URLQueryItem = .init(name: "componentId", value: ConstantParameters.componentId)
        return [componentId]
    }
}

struct ComponentSettingsResponse: Decodable {
    let id: String?
    let value: String?
    let name: String?
    let dataType: String?
    let yamlKey: String?
    let valueWithPlaceHolder: String?
    let isConstant: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case value = "Value"
        case name = "Name"
        case dataType = "DataType"
        case yamlKey = "YamlKey"
        case valueWithPlaceHolder = "ValueWithPlaceHolder"
        case isConstant = "isConstant"
    }
}


extension NetworkServiceProtocol {
	func getComponentSettings(cacheOption: CacheOption) async throws -> [ComponentSettingsResponse]? {
		return try await self.requestV2(ComponentSettingsRequest(), responseModel: [ComponentSettingsResponse].self, cacheOption: cacheOption)
    }
}

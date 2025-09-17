//
//  NetworkService+ShipNetworkReachable.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/11/24.
//

import Foundation

struct ShipReachableRequest: HTTPRequestProtocol {
	var headers: (any HTTPHeadersProtocol)?
	var httpMethod: HTTPMethod = .HEAD
	var httpHeaders: HTTPHeaders? = nil
	var path: String = "/svc/dxpcore/info"
	var body: Data?
	var timeoutInterval: TimeInterval = 3.0
}

extension NetworkServiceProtocol {
	func isShipNetworkReachable() async -> Bool {
		do {
			_ = try await requestV2(ShipReachableRequest(), responseModel: EmptyResponse.self)
			return true
		} catch {
			return false
		}
	}
}

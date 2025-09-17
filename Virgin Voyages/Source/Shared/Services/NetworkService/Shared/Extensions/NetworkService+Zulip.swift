//
//  NetworkService+Zulip.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/10/25.
//


import Foundation

enum ZulipEnvironment: NetworkServiceEnvironmentProtocol {

	case zulipInt
	case zulipCert
	case zulipStage
	case zulipProd

	var description: String {
		switch self {
		case .zulipInt: "zulipInt"
		case .zulipCert: "zulipCert"
		case .zulipStage: "zulipStage"
		case .zulipProd: "zulipProd"
		}
	}

	var scheme: String {
		return "https"
	}

	var host: String {
		switch self {
		case .zulipInt:
			return "zulip-integration.ship.virginvoyages.com"
		case .zulipCert:
			return "zulip-cert.ship.virginvoyages.com"
		case .zulipStage:
			return "stage-zulip.gcp.virginvoyages.com"
		case .zulipProd:
			return "chat.ship.virginvoyages.com"
		}
	}

	var basicToken: String {
		switch self {
		case .zulipInt:
			return "MzhjMWFiNTEtY2U5Ny00MzljLTlkMjAtYzQ4ZDcyNGUxZmU1Okc1NlRWWVk3OGJqcWREWU9oNzk5"
		case .zulipCert:
			return "MzhjMWFiNTEtY2U5Ny00MzljLTlkMjAtYzQ4ZDcyNGUxZmU1Okc1NlRWWVk3OGJqcWREWU9oNzk5"
		case .zulipStage:
			return "NzVjZmNiOTgtNzllOS00OTNiLWJlYjUtMjlmZWQxNjk3MmQ2OlFrTHNuNk16eUo="
		case .zulipProd:
			return "NzVjZmNiOTgtNzllOS00OTNiLWJlYjUtMjlmZWQxNjk3MmQ2OlFrTHNuNk16eUo="
		}
	}
}

class ZulipEnvironmentProvider: NetworkServiceEnvironmentProvider {
	func getEnvironment() -> any NetworkServiceEnvironmentProtocol {
		let appEnvironment: AppEnvironment = AppConfig.shared.appEnvironment
		var environment: ZulipEnvironment = .zulipProd
		switch appEnvironment {
		case .int:
			environment = .zulipInt
		case .cert:
			environment = .zulipCert
		case .stage:
			environment = .zulipStage
		case .prod:
			environment = .zulipProd
		}
		return environment
	}
}

extension NetworkService {
	static func createZulipService() -> NetworkServiceProtocol {
		let zulipEnvironmentProvider = ZulipEnvironmentProvider()
		return NetworkService(
			environmentProvider: zulipEnvironmentProvider,
			networkCacheStore: PersistedNetworkCacheStore.shared
		)
	}
}

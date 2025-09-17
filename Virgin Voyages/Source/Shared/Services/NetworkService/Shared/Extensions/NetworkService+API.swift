//
//  NetworkService+API.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/10/25.
//


import Foundation

enum APIEnvironment: NetworkServiceEnvironmentProtocol {

	enum Network: Codable {
		case shore
		case ship
	}

	case int(Network)
	case cert(Network)
	case stage(Network)
	case prod(Network)

	private enum CodingKeys: String, CodingKey {
		case type
		case network
	}

	var scheme: String {
		return "https"
	}

	var host: String {
		switch self {
		case .cert(let network):
			return certHost(for: network)
		case .stage(let network):
			return stageHost(for: network)
		case .prod(let network):
			return prodHost(for: network)
		case .int(let network):
			return intHost(for: network)
		}
	}

	private func certHost(for network: Network) -> String {
		switch network {
		case .shore:
			return "cert.gcpshore.virginvoyages.com"
		case .ship:
            return "certmobile.ship.virginvoyages.com"
		}
	}

	private func stageHost(for network: Network) -> String {
		switch network {
		case .shore:
			return "stage.gcp.virginvoyages.com"
		case .ship:
			return "stagemobile.ship.virginvoyages.com"
		}
	}

	private func prodHost(for network: Network) -> String {
		switch network {
		case .shore:
			return "mobile.shore.virginvoyages.com"
		case .ship:
			return "mobile.ship.virginvoyages.com"
		}
	}

	private func intHost(for network: Network) -> String {
		switch network {
		case .shore:
			return "int.gcpshore.virginvoyages.com"
		case .ship:
			return "intmobile.ship.virginvoyages.com"
		}
	}

	var basicToken: String {
		switch self {
		case .int(_):
			return "MzhjMWFiNTEtY2U5Ny00MzljLTlkMjAtYzQ4ZDcyNGUxZmU1Okc1NlRWWVk3OGJqcWREWU9oNzk5"
		case .cert(_):
			return "MzhjMWFiNTEtY2U5Ny00MzljLTlkMjAtYzQ4ZDcyNGUxZmU1Okc1NlRWWVk3OGJqcWREWU9oNzk5"
		case .stage(_):
			return "NzVjZmNiOTgtNzllOS00OTNiLWJlYjUtMjlmZWQxNjk3MmQ2OlFrTHNuNk16eUo"
		case .prod(_):
			return "NzVjZmNiOTgtNzllOS00OTNiLWJlYjUtMjlmZWQxNjk3MmQ2OlFrTHNuNk16eUo"
		}
	}
}

class ShipOnlyEnvironmentProvider: NetworkServiceEnvironmentProvider {
	func getEnvironment() -> NetworkServiceEnvironmentProtocol {
		return getEnvironmentForNetwork(.ship)
	}

	func getEnvironmentForNetwork(_ network: APIEnvironment.Network) -> APIEnvironment {
		let appEnvironment: AppEnvironment = AppConfig.shared.appEnvironment
		var environment: APIEnvironment = .prod(network)
		switch appEnvironment {
		case .int:
			environment = .int(network)
		case .cert:
			environment = .cert(network)
		case .stage:
			environment = .stage(network)
		case .prod:
			environment = .prod(network)
		}

		return environment
	}
}

class APIEnvironmentProvider: NetworkServiceEnvironmentProvider {

	private var lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol

	init(lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()) {
		self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
	}

	func getEnvironment() -> NetworkServiceEnvironmentProtocol {
		let connectionLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
		let network: APIEnvironment.Network = connectionLocation == .ship ? .ship : .shore
		return getEnvironmentForNetwork(network)
	}

	func getEnvironmentForNetwork(_ network: APIEnvironment.Network) -> APIEnvironment {
		let appEnvironment: AppEnvironment = AppConfig.shared.appEnvironment
		var environment: APIEnvironment = .prod(network)
		switch appEnvironment {
		case .int:
			environment = .int(network)
		case .cert:
			environment = .cert(network)
		case .stage:
			environment = .stage(network)
		case .prod:
			environment = .prod(network)
		}

		return environment
	}
}

protocol NetworkServiceFactoryProtocol {
	func createNetworkService() -> NetworkServiceProtocol
}

class APINetworkServiceFactory: NetworkServiceFactoryProtocol {
	func createNetworkService() -> NetworkServiceProtocol {
		let environmentProvider = APIEnvironmentProvider()
		return NetworkService(environmentProvider: environmentProvider, networkCacheStore: PersistedNetworkCacheStore.shared)
	}

	func createShipNetworkService() -> NetworkServiceProtocol {
		let environmentProvider = ShipOnlyEnvironmentProvider()
		return NetworkService(environmentProvider: environmentProvider,
							  networkCacheStore: PersistedNetworkCacheStore.shared)
	}
}

extension NetworkService {
	static func create() -> NetworkServiceProtocol {
		return APINetworkServiceFactory().createNetworkService()
	}

	static func createForShip() -> NetworkServiceProtocol {
		return APINetworkServiceFactory().createShipNetworkService()
	}
}


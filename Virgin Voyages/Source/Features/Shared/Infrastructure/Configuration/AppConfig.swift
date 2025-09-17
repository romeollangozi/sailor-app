//
//  AppConfig.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 1/31/25.
//

import Foundation

enum BuildConfiguration {
	case debug
	case release
}

enum AppEnvironment: Codable, CaseIterable, Identifiable {
	case int
	case cert
	case stage
	case prod

	var id: String {
		return description
	}

	var description: String {
		switch self {
		case .int:
			return "Int"
		case .cert:
			return "Cert"
		case .stage:
			return "Stage"
		case .prod:
			return "Prod"
		}
	}
}

extension UserDefaultsKey {
	static let appEnvironmentKey = UserDefaultsKey("AppEnvironmentKey")
}

class AppConfig {

	private let userDefaultsRepository: KeyValueRepositoryProtocol

	static let shared = AppConfig()

	var buildConfiguration: BuildConfiguration {
#if DEBUG
		return .debug
#else
		return .release
#endif
	}

	var appEnvironment: AppEnvironment {
		get {
			guard let appEnvironment: AppEnvironment = userDefaultsRepository.getObject(key: .appEnvironmentKey) else {
				if buildConfiguration == .debug {
					return .cert
				}
				return .prod
			}
			return appEnvironment
		}
		set {
			try? userDefaultsRepository.setObject(key: .appEnvironmentKey, value: newValue)
		}
	}

	var apptentiveKey: String {
		switch appEnvironment {
		case .int:
			return "IOS-VIRGIN-VOYAGES-75f2cfb4c077"
		case .cert:
			return "IOS-VIRGIN-VOYAGES-75f2cfb4c077"
		case .stage:
			return "IOS-VIRGIN-VOYAGES-75f2cfb4c077"
		case .prod:
			return "IOS-VIRGIN-VOYAGES-75f2cfb4c077"
		}
	}

	var apptentiveSignature: String {
		switch appEnvironment {
		case .int:
			return "47f3648e800774dbf14cf56fe511b110"
		case .cert:
			return "47f3648e800774dbf14cf56fe511b110"
		case .stage:
			return "47f3648e800774dbf14cf56fe511b110"
		case .prod:
			return "47f3648e800774dbf14cf56fe511b110"
		}
	}

	private init(userDefaultsRepository: KeyValueRepositoryProtocol = UserDefaultsKeyValueRepository()) {
		self.userDefaultsRepository = userDefaultsRepository
	}

}

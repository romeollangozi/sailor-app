//
//  WiFiConnectionService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/28/25.
//

import UIKit
import NetworkExtension

enum WiFiConnectionError: Error {
	case userDenied
	case alreadyConnected
	case invalidConfiguration
	case unknownError
	case connectionFailed
}

protocol WiFiConnectionServiceProtocol {
	func connect(ssid: String) async throws
}

class WiFiConnectionService: WiFiConnectionServiceProtocol {

	func connect(ssid: String) async throws {
		let configuration = NEHotspotConfiguration(ssid: ssid)

		try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
			NEHotspotConfigurationManager.shared.apply(configuration) { error in
				if let nsError = error as NSError? {
					if let hotspotError = NEHotspotConfigurationError(rawValue: nsError.code) {
						switch hotspotError {
						case .userDenied:
							continuation.resume(throwing: WiFiConnectionError.userDenied)
						case .alreadyAssociated:
							self.validateConnection(for: ssid, continuation: continuation)
						case .invalid:
							continuation.resume(throwing: WiFiConnectionError.invalidConfiguration)
						default:
							continuation.resume(throwing: WiFiConnectionError.unknownError)
						}
					} else {
						continuation.resume(throwing: WiFiConnectionError.unknownError)
					}
				} else {
					self.validateConnection(for: ssid, continuation: continuation)
				}
			}
		}
	}

	private func validateConnection(for ssid: String, continuation: CheckedContinuation<Void, Error>) {
		Task {
			if let currentSSID = await fetchCurrentSSID(), currentSSID == ssid {
				continuation.resume(returning: ())
			} else {
				continuation.resume(throwing: WiFiConnectionError.connectionFailed)
			}
		}
	}

	private func fetchCurrentSSID() async -> String? {
		if let network = await NEHotspotNetwork.fetchCurrent() {
			return network.ssid
		}
		return nil
	}
}

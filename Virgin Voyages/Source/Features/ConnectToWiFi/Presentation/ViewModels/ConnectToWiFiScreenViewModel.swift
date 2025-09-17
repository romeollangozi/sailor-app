//
//  ConnectToWiFiScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/28/25.
//

import SwiftUI

@Observable class ConnectToWiFiScreenViewModel: ConnectToWiFiScreenViewModelProtocol {
	var currentState: WiFiViewState = .landing
	var shouldShowLocationPermissionsSheet: Bool = false

	private let connectToShipWiFiUseCase: ConnectToShipWiFiUseCase
	private let openSettingsUseCase: OpenSettingsUseCase
	private let fetchShipWiFiConnectivityStateUseCase: FetchShipWiFiConnectivityStateUseCase

	init(
		connectToShipWiFiUseCase: ConnectToShipWiFiUseCase = ConnectToShipWiFiUseCase(),
		openSettingsUseCase: OpenSettingsUseCase = OpenSettingsUseCase(),
		fetchShipWiFiConnectivityStateUseCase: FetchShipWiFiConnectivityStateUseCase = FetchShipWiFiConnectivityStateUseCase()
	) {
		self.connectToShipWiFiUseCase = connectToShipWiFiUseCase
		self.openSettingsUseCase = openSettingsUseCase
		self.fetchShipWiFiConnectivityStateUseCase = fetchShipWiFiConnectivityStateUseCase
	}

	func connectToShipWiFi() {
		Task {
			let result = await connectToShipWiFiUseCase.execute()
			switch result {
			case .connectedToWiFi:
				return
			case .failedToConnectToWiFi:
				await showTroubleshootView()
			case .locationPermissionsNotGranted:
				await showLocationPermissionsSheet()
			case .userDeclined:
				return
			}
		}
	}

	func onAppear() {
		let state = fetchShipWiFiConnectivityStateUseCase.execute()
		switch state {
		case .precruise:
			currentState = .landing
		case .noDataConnection:
			currentState = .noConnection
		case .noDataConnectionWelcomeAboard:
			currentState = .landing
		case .offlineModePortDay:
			currentState = .landing
		case .troubleshooting:
			currentState = .troubleshoot
		case .connectedToShipWiFi:
			currentState = .landing
		}
	}

	func openSettings() {
		openSettingsUseCase.execute()
	}

	func openWiFiSettings() {
		openSettingsUseCase.execute()
	}

	func dismissLocationPermissionsSheet() {
		shouldShowLocationPermissionsSheet = false
	}

	@MainActor
	private func showTroubleshootView() {
		currentState = .troubleshoot
	}

	@MainActor
	private func showLocationPermissionsSheet() {
		shouldShowLocationPermissionsSheet = true
	}
}

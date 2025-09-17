//
//  ConnectToWiFiScreen.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 03/07/25.
//

import SwiftUI

enum WiFiViewState {
	case troubleshoot
	case noConnection
	case landing
}

protocol ConnectToWiFiScreenViewModelProtocol {
	var currentState: WiFiViewState { get }
	var shouldShowLocationPermissionsSheet: Bool { get set }
	func onAppear()
	func connectToShipWiFi()
	func openSettings()
	func openWiFiSettings()
	func dismissLocationPermissionsSheet()
}

struct ConnectToWiFiScreen: View {
	@State var viewModel: ConnectToWiFiScreenViewModelProtocol

	init(viewModel: ConnectToWiFiScreenViewModelProtocol) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		ZStack {
			switch viewModel.currentState {
			case .troubleshoot:
				ConnectToWiFiTroubleshootView(connectToShipWiFi: {
					viewModel.connectToShipWiFi()
				}, openWiFiSettings: {
					viewModel.openWiFiSettings()
				})

			case .noConnection:
				ConnectToWiFiNoConnectionView(connectToShipWiFi: {
					viewModel.connectToShipWiFi()
				}, openWiFiSettings: {
					viewModel.openWiFiSettings()
				})

			case .landing:
				ConnectToWiFiLandingView(connectToShipWiFi: {
					viewModel.connectToShipWiFi()
				}, openWiFiSettings: {
					viewModel.openWiFiSettings()
				})
			}
		}
		.sheet(isPresented: $viewModel.shouldShowLocationPermissionsSheet) {
			ConnectToWiFiLocationPermissionsSheet(openSettings: {
				viewModel.openSettings()
			}, openWiFiSettings: {
				viewModel.openWiFiSettings()
			}, dismiss: {
				viewModel.dismissLocationPermissionsSheet()
			})
			.presentationDetents([.medium])
		}
		.onAppear {
			viewModel.onAppear()
		}
	}
}

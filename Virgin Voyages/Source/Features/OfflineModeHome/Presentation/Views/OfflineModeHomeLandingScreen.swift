//
//  OfflineModeHomeLandingScreen.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI
import VVUIKit

protocol OfflineModeHomeLandingScreenViewModelProtocol {
	var navigationPath: NavigationPath { get set }
	var shipTimeFormattedText: String? { get }
	var allAboardTimeFormattedText: String? { get }
	var lastUpdatedText: String? { get }

	func onAppear()
	func navigateToAgenda()
	func navigateToLineUp()
}

struct OfflineModeHomeLandingScreen: View {

	@State var viewModel: OfflineModeHomeLandingScreenViewModelProtocol
	let navigateToConnectToWiFi: () -> Void

	@State private var safeAreaInsets: EdgeInsets = EdgeInsets(.zero)

	var body: some View {
		GeometryReader { screenProxy in
			NavigationStack(path: $viewModel.navigationPath) {
				OfflineModeHomeContentView(
					shipTimeFormattedText: viewModel.shipTimeFormattedText,
					allAboardTimeFormattedText: viewModel.allAboardTimeFormattedText,
					lastUpdatedText: viewModel.lastUpdatedText,
					safeAreaInsets: safeAreaInsets,
					navigateToAgenda: {
						viewModel.navigateToAgenda()
					},
					navigateToEventLineup: {
						viewModel.navigateToLineUp()
					}, navigateToConnectToWiFi: {
						navigateToConnectToWiFi()
					})
				.navigationDestination(for: OfflineModeHomeLandingNavigationRoute.self) { route in
					switch route {
					case .agenda:
						OfflineModeMyAgendaScreen(safeAreaInsets: safeAreaInsets)
							.toolbar(.hidden)
					case .eventLineUp:
						OfflineModeLineUpScreen(safeAreaInsets: safeAreaInsets)
							.toolbar(.hidden)
					}
				}
			}
			.onAppear {
				safeAreaInsets = screenProxy.safeAreaInsets
			}
		}
		.onAppear() {
			viewModel.onAppear()
		}
	}

	init(
		viewModel: OfflineModeHomeLandingScreenViewModelProtocol,
		navigateToConnectToWiFi: @escaping () -> Void
	) {
		_viewModel = State(wrappedValue: viewModel)
		self.navigateToConnectToWiFi = navigateToConnectToWiFi
	}
}

struct OfflineModeHomeLandingScreen_Previews: PreviewProvider {

	struct MockOfflineModeHomeLandingScreenViewModel: OfflineModeHomeLandingScreenViewModelProtocol {
		
		var appCoordinator: any CoordinatorProtocol = AppCoordinator.shared

		func navigateToAgenda() {
		}
		
		func navigateToLineUp() {
		}

		var navigationPath: NavigationPath = NavigationPath()

		var shipTimeFormattedText: String? = "3:57pm"
		var allAboardTimeFormattedText: String? = "6:30pm"
		var lastUpdatedText: String? = "Last updated 11:57am Today"

		func onAppear() {
		}
	}

	static var previews: some View {
		OfflineModeHomeLandingScreen(viewModel: MockOfflineModeHomeLandingScreenViewModel(), navigateToConnectToWiFi: {
		})
			.previewLayout(.sizeThatFits) // Adjust preview size
	}
}

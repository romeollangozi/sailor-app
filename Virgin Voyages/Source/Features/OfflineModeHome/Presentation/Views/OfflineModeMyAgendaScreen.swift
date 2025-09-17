//
//  OfflineModeMyAgendaScreen.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import SwiftUI
import VVUIKit

protocol OfflineModeMyAgendaScreenViewModelProtocol {
	var shipTimeFormattedText: String? { get }
	var allAboardTimeFormattedText: String? { get }
	var lastUpdatedText: String? { get }
	var eventCardModels: [OfflineModeMyAgendaEventCardModel] { get }

	func onAppear()
	func navigateBack()
}

struct OfflineModeMyAgendaScreen: View {

	@State var viewModel: OfflineModeMyAgendaScreenViewModelProtocol
	private let safeAreaInsets: EdgeInsets

	var body: some View {
		OfflineModeMyAgendaContentView(
			shipTimeFormattedText: viewModel.shipTimeFormattedText,
			allAboardTimeFormattedText: viewModel.allAboardTimeFormattedText,
			lastUpdatedText: viewModel.lastUpdatedText,
			eventCardModels: viewModel.eventCardModels,
			safeAreaInsets: safeAreaInsets,
			back: {
				viewModel.navigateBack()
			}
		)
		.onAppear() {
			viewModel.onAppear()
		}
	}

	public init(
		viewModel: OfflineModeMyAgendaScreenViewModelProtocol = OfflineModeMyAgendaScreenViewModel(),
		safeAreaInsets: EdgeInsets
	) {
		_viewModel = State(wrappedValue: viewModel)
		self.safeAreaInsets = safeAreaInsets
	}
}

struct OfflineModeMyAgendaScreen_Previews: PreviewProvider {

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

//
//  OfflineModeLineUpScreen.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/14/25.
//

import SwiftUI
import VVUIKit

protocol OfflineModeLineUpScreenViewModelProtocol {
	var shipTimeFormattedText: String? { get }
	var allAboardTimeFormattedText: String? { get }
	var lastUpdatedText: String? { get }
	var lineUpHourEvents: [OfflineModeLineUpHourEvents] { get }
    var firstUpcomingEventIndex: Int? { get }
    var shipDateTime: Date { get }

	func onAppear()
	func navigateBack()
}

struct OfflineModeLineUpScreen: View {

	@State var viewModel: OfflineModeLineUpScreenViewModelProtocol
	private let safeAreaInsets: EdgeInsets

	var body: some View {
		OfflineModeLineUpContentView(
			shipTimeFormattedText: viewModel.shipTimeFormattedText,
			allAboardTimeFormattedText: viewModel.allAboardTimeFormattedText,
			lastUpdatedText: viewModel.lastUpdatedText,
			eventsByHour: viewModel.lineUpHourEvents,
            firstUpcomingEventIndex: viewModel.firstUpcomingEventIndex,
            selectedDay: viewModel.shipDateTime.dayName,
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
		viewModel: OfflineModeLineUpScreenViewModelProtocol = OfflineModeLineUpScreenViewModel(),
		safeAreaInsets: EdgeInsets
	) {
		_viewModel = State(wrappedValue: viewModel)
		self.safeAreaInsets = safeAreaInsets
	}
}

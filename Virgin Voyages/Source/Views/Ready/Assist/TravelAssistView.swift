//
//  TravelAssistView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/24/24.
//

import SwiftUI
import VVUIKit

struct TravelAssistView: View {
	@State var viewModel: TravelAssistViewModelProtocol
	@Environment(\.dismiss) var dismiss

	init(viewModel: TravelAssistViewModelProtocol = TravelAssistViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		ScreenView(name: "Travel Assist", viewModel: TravelAssistViewer(), content: $viewModel.travelAssist) { assist in
			TravelAssistScreen(assist: assist)
		}
		.toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
		.navigationBarBackButtonHidden()
		.navigationTitle("")
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				SailableBackButton {
					dismiss()
				}
			}
		}
	}
}

protocol TravelAssistViewModelProtocol {
	var travelAssist: TravelAssistViewer.Content? { get set }
	func loadData()
}

@Observable class TravelAssistViewModel: BaseViewModel, TravelAssistViewModelProtocol {
	var travelAssist: TravelAssistViewer.Content?
    private let checkInStatusEventNotificationService: CheckInStatusEventNotificationService
    private let listenerKey = "TravelAssistViewModel"

    init(checkInStatusEventNotificationService: CheckInStatusEventNotificationService = .shared) {
        self.checkInStatusEventNotificationService = checkInStatusEventNotificationService
        super.init()
        self.startObservingEvents()
    }

	func loadData() {
		guard let sailor = try? AuthenticationService.shared.currentSailor() else { return }
		Task {
            let travelAssist = try? await sailor.fetch(TravelAssistViewer())
			await executeOnMain({
				self.travelAssist = travelAssist
			})
		}
	}

    func startObservingEvents() {
        checkInStatusEventNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_ event: CheckInkEventNotification) {
        switch event {
        case .checkInHasChanged:
            Task {
                loadData()
            }
        }
    }
}


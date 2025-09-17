//
//  ShoreThingPortScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import Combine
import SwiftUI

@Observable class ShoreThingPortScreenViewModel: BaseViewModel, ShoreThingPortScreenViewModelProtocol {
        
    private let getShoreThingPortsUseCase: GetShoreThingPortsUseCaseProtocol
    var screenState: ScreenState = .loading
    var shoreThingPorts: ShoreThingPorts = .empty()
    var selectedPort: ShoreThingPort = .empty()
    var showGuide: ShoreThingPort?
    var showEventEditView: Bool = false
    var countdownTitle: String = ""
    let countdownTimer = CountdownTimer()
    private var cancellables = Set<AnyCancellable>()

    init(getShoreThingPortsUseCase: GetShoreThingPortsUseCaseProtocol = GetShoreThingPortsUseCase()) {
        self.getShoreThingPortsUseCase = getShoreThingPortsUseCase
    }
    
    func onFirstAppear() {
        Task {
            await loadShoreThingPorts()
			
			selectCurrentPort()
			
			if let leadTime = self.shoreThingPorts.leadTime {
				self.countdownTimer.startCountdown(secondsLeft: leadTime.timeLeftToBookingStartInSeconds)
				self.observeCountdown()
			}
        }
    }
	
	func onReAppear() {
		
	}
    
    func onRefresh() {
        Task {
            await loadShoreThingPorts()
			
			selectCurrentPort()
			
			if let leadTime = self.shoreThingPorts.leadTime {
				self.countdownTimer.startCountdown(secondsLeft: leadTime.timeLeftToBookingStartInSeconds)
				self.observeCountdown()
			}
        }
    }
    
    private func loadShoreThingPorts() async {
        if let result = await executeUseCase({
			try await self.getShoreThingPortsUseCase.execute(useCache: true)
        }) {
            await executeOnMain({
                self.shoreThingPorts = result
                self.screenState = .content
            })
        } else {
            await executeOnMain({
                self.screenState = .error
            })
        }
    }
    
    private func selectCurrentPort() {
        if let current = shoreThingPorts.items.first(where: { $0.dayType == .current }) {
            self.selectedPort = current
        } else if let future = shoreThingPorts.items
                    .filter({ $0.dayType == .future })
                    .sorted(by: { $0.sequence < $1.sequence })
                    .first {
            self.selectedPort = future
        } else if let last = shoreThingPorts.items.last {
            self.selectedPort = last
        }
    }
    
    private func observeCountdown() {
        countdownTimer.$countdownText
            .receive(on: RunLoop.main)
            .sink { [weak self] countdown in
                guard let self else { return }
                self.countdownTitle = "Shore Thing booking opens in \(countdown)"
                //Refresh page when minutes left to opening times == 0
                if countdown.isEmpty {
                    self.onRefresh()
                }
            }
            .store(in: &cancellables)
    }
}

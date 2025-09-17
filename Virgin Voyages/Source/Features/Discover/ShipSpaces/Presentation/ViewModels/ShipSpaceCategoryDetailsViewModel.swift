//
//  ShipSpaceCategoryDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import SwiftUI
import Foundation
import Combine

@Observable class ShipSpaceCategoryDetailsViewModel: BaseViewModel, ShipSpaceCategoryDetailsScreenViewModelProtocol {
    
    private let getShipSpaceCategoryUseCase: GetShipSpaceCategoryDetailsUseCaseProtocol
    private let categoryCode: String

    var shipSpaceCategory: ShipSpaceCategoryDetails = ShipSpaceCategoryDetails.empty()
    var screenState: ScreenState = .loading
    
    let countdownTimer = CountdownTimer()
    var countdownTitle: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(categoryCode: String, getShipSpaceCategoryUseCase: GetShipSpaceCategoryDetailsUseCaseProtocol = GetShipSpaceCategoryDetailsUseCase()) {
        self.categoryCode = categoryCode
        self.getShipSpaceCategoryUseCase = getShipSpaceCategoryUseCase
    }
    
    func onAppear() async {
        await loadShipSpaceCategory(categoryCode: categoryCode)
        screenState = .content
    }
    
    func onRefresh() async {
        await loadShipSpaceCategory(categoryCode: categoryCode, useCache: false)
        screenState = .content
    }
    
    private func loadShipSpaceCategory(categoryCode: String, useCache: Bool = true) async {
        if let result = await executeUseCase({
			try await self.getShipSpaceCategoryUseCase.execute(shipSpaceCategoryCode: categoryCode, useCache: useCache)
        }) {
            self.shipSpaceCategory = result
            if shipSpaceCategory.leadTime.isCountdownStarted {
                await self.executeOnMain({
                    self.countdownTimer.startCountdown(secondsLeft: shipSpaceCategory.leadTime.timeLeftToBookingStartInSeconds)
                    self.observeCountdown()
                })
            }
        }
    }
    
    private func observeCountdown() {
        countdownTimer.$countdownText
            .receive(on: RunLoop.main)
            .sink { [weak self] countdown in
                guard let self else { return }
                self.countdownTitle = "Spa Treatment booking opens in \(countdown)"
                //Refresh page when minutes left to opening times == 0
                if countdown.isEmpty {
                    Task{
                        await self.onRefresh()
                    }
                }
            }
            .store(in: &cancellables)
    }

    func subheader(from shipSpace: ShipSpaceDetails) -> String {
        return shipSpace.shortDescription + " | " + shipSpace.location
    }
}

//
//  ShipEatsOpeningTimeScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.5.25.
//

import Foundation

@Observable class ShipEatsOpeningTimeScreenViewModel: BaseViewModel, ShipEatsOpeningTimeScreenViewModelProtocol {
    private let getShipEatsOpeningTimeUseCase: GetShipEatsOpeningTimeUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var shipEatsOpeninTime: ShipEatsOpeninTime = .empty()
    
    init(getShipEatsOpeningTimeUseCase: GetShipEatsOpeningTimeUseCaseProtocol = GetShipEatsOpeningTimeUseCase()) {
        self.getShipEatsOpeningTimeUseCase = getShipEatsOpeningTimeUseCase
    }
    
    func onAppear() {
        Task {
            await loadData()
        }
    }
    
    func onRefresh() {
        Task {
            await loadData()
        }
    }
    
    func onBackTapped() {
        executeNavigationCommand(ServiceCoordinator.ServiceBackCommand())
    }
    
    private func loadData() async {
        if let result = await executeUseCase({
            try await self.getShipEatsOpeningTimeUseCase.execute()
        }) {
            await executeOnMain({
                self.shipEatsOpeninTime = result
                self.screenState = .content
            })
        } else {
            await executeOnMain({
                self.screenState = .error
            })
        }
    }
}

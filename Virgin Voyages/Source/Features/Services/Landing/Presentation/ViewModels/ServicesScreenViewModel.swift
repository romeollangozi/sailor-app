//
//  ServicesScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/23/25.
//

import Foundation


@Observable class ServicesScreenViewModel: BaseViewModel, ServicesScreenViewModelProtocol {
	private let getSailorShoreOrShipUseCase : GetSailorShoreOrShipUseCaseProtocol
	
	var isOnShip: Bool = false
    var screenState: ScreenState = .loading
    
	init(getSailorShoreOrShipUseCase : GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase()) {
		self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
	}
	
    func onAppear() {
		isOnShip = getSailorShoreOrShipUseCase.execute().isOnShip
        screenState = .content
    }
    
    func onRefresh() {
		isOnShip = getSailorShoreOrShipUseCase.execute().isOnShip
        screenState = .content
    }
    
    func onCabinServiceTapped() {
		if isOnShip {
			executeNavigationCommand(ServiceCoordinator.CabinServiceCommand())
		} else {
			executeNavigationCommand(ServiceCoordinator.CabinServiceOpeningTimeCommand())
		}
    }
    
    func onShipEatsDeliveryTapped() {
        if isOnShip {
            executeNavigationCommand(ServiceCoordinator.ShipEatsCommand())
        } else {
            executeNavigationCommand(ServiceCoordinator.ShipEatsOpeningTimeCommand())
        }
    }
    
    func onHelpAndSupportTapped() {
        executeNavigationCommand(ServiceCoordinator.HelpAndSupportCommand())
    }
}

//
//  MeLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.3.25.
//

import Foundation

@MainActor
protocol MeLandingScreenViewModelProtocol {
	var appCoordinator: AppCoordinator { get set }
    func onAppear()

    func navigateBack()
    func openMeAddonsScreen()
    func openAddonsList()
    func openHomeDashboard()
    func updateSailorReservation(reservationNumber: String)

}

@MainActor
@Observable class MeLandingScreenViewModel: BaseViewModel, MeLandingScreenViewModelProtocol {
    private let getVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let auhenticationService: AuthenticationServiceProtocol
	
	let eventNotificationService: ReservationStatusEventNotificationService
	var appCoordinator: AppCoordinator = .shared

    init(
        getVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol = GetMyVoyageHeaderUseCase(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		eventNotificationService: ReservationStatusEventNotificationService = .shared,
		auhenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	) {
		self.getVoyageHeaderUseCase = getVoyageHeaderUseCase
		self.currentSailorManager = currentSailorManager
		self.eventNotificationService = eventNotificationService
		self.auhenticationService = auhenticationService
    }
    
    func navigateBack() {
        appCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateBack()
    }

    func openMeAddonsScreen() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAddonsScreenCommand())
    }

    func openAddonsList() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonsListCommand())
    }

    func openHomeDashboard() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenHomeDashboardScreenCommand())
    }

    func updateSailorReservation(reservationNumber: String) {
        Task {
            do {
                try await auhenticationService.reloadReservation(
                    reservationNumber: reservationNumber,
                    displayLoadingFlow: true
                )
                eventNotificationService.publish(.newReservationReceived)
            } catch {
                // TODO: handle/log error if needed
            }
        }
    }

    func onAppear() {}
}

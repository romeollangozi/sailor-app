//
//  HomePlannerOnboardViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import Observation
import SwiftUI

protocol HomePlannerOnboardViewModelProtocol {
    var homePlanner: HomePlannerSection { get }
    var screenState: ScreenState { get set }
    var isNonInventoried: Bool { get }

    func onAppear()
	func reload()
    func didTapMyAgenda()
    func didTapEatery()
    func didTapAppointment(appointment: HomePlannerSection.PlannerNextActivity)
    func didTapLineUpEvent()
    func getVisibleUpcomingEntertainments() -> [HomePlannerSection.PlannerUpcomingEntertainment]
}

@Observable
class HomePlannerOnboardViewModel: BaseViewModel, HomePlannerOnboardViewModelProtocol {
    private let getHomePlannerUseCase: GetHomePlannerUseCaseProtocol
   
    var homePlanner: HomePlannerSection
    var screenState: ScreenState = .loading
    var isNonInventoried: Bool {
        homePlanner.nextActivity.inventoryState == .nonInventoried ? true : false
    }
    
    init(getHomePlannerUseCase: GetHomePlannerUseCaseProtocol = GetHomePlannerUseCase(),
         homePlanner: HomePlannerSection = HomePlannerSection.empty()) {
        self.getHomePlannerUseCase = getHomePlannerUseCase
        self.homePlanner = homePlanner
    }
    
    func onAppear() {
        
    }
	
	func reload() {
		Task { [weak self] in
			guard let self else { return }
			
			await loadHomePlanner()
		}
	}
    
    func didTapMyAgenda() {
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
    }
    
    func didTapEatery() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenEateriesListScreenCommand())
    }
    
    func didTapAppointment(appointment: HomePlannerSection.PlannerNextActivity) {
        switch appointment.bookableType {
        case .eatery:
			navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenHomeEateryReceipeCommand(appointmentId: appointment.appointmentId))
            break
        case .shoreExcursion:
			navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenShoreExcursionReceipeCommand(appointmentId: appointment.appointmentId))
        case .treatment:
			navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenTreatmentReceipeCommand(appointmentId: appointment.appointmentId))
        case .entertainment:
			navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenEntertainmentReceipeCommand(appointmentId: appointment.appointmentId))
        case .addOns:
            break
        case .undefined:
            break
        }
    }
    
    func didTapLineUpEvent() {
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenDiscoverLineUpEventsCommand())
    }
    
    func getVisibleUpcomingEntertainments() -> [HomePlannerSection.PlannerUpcomingEntertainment] {
        return Array(homePlanner.upcomingEntertainments.prefix(2))
    }
    
    // MARK: - Private Methods
    private func loadHomePlanner() async {
		if let result = await executeUseCase({
			try await self.getHomePlannerUseCase.execute()
		}) {
			await executeOnMain {
				self.homePlanner = result
				self.screenState = .content
			}
		}
    }
}

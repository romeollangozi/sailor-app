//
//  HomeNotificationsViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 13.3.25.
//

import Observation
import SwiftUI

protocol HomeNotificationsViewModelProtocol {
    var homeNotifications: HomeNotificationsSection { get }
    var screenState: ScreenState { get set }

    func onAppear()
	func reload()
    func didTapNotifications()
}

@Observable
class HomeNotificationsViewModel: BaseViewModel, HomeNotificationsViewModelProtocol {
    private let getHomeNotificationsUseCase: GetHomeNotificationsUseCaseProtocol
   
    var homeNotifications: HomeNotificationsSection
    var screenState: ScreenState = .loading

    init(getHomeNotificationsUseCase: GetHomeNotificationsUseCaseProtocol = GetHomeNotificationsUseCase(),
         homeNotifications: HomeNotificationsSection = HomeNotificationsSection.empty()) {
        self.getHomeNotificationsUseCase = getHomeNotificationsUseCase
        self.homeNotifications = homeNotifications
    }
    
    func onAppear() {

    }
	
	func reload() {
		Task {
			[weak self] in
			guard let self else { return }
			
			await loadHomeNotifications()
			
			await executeOnMain({
				self.screenState = .content
			})
		}
	}
    
    func didTapNotifications() {
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())
    }

    private func loadHomeNotifications() async {
        if let result = await executeUseCase({
            try await self.getHomeNotificationsUseCase.execute()
        }) {
			await executeOnMain({
				print("result.unReadCount : ", result.unReadCount)
				self.homeNotifications = result
			})
        } else {
			await executeOnMain({
				self.homeNotifications = .empty()
			})
        }
    }

}

//
//  HomeActionsViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 25.3.25.
//

import Observation
import SwiftUI

protocol HomeActionsViewModelProtocol {
    var homeActions: HomeActionsSection { get }

    func didTapAction(item: HomeActionsSection.Action)
}

@Observable
class HomeActionsViewModel: BaseViewModel, HomeActionsViewModelProtocol {
    
    private var appCoordinator: AppCoordinator = .shared
    var homeActions: HomeActionsSection
    
    init(homeActions: HomeActionsSection = HomeActionsSection.empty()) {
        self.homeActions = homeActions
    }
    
    func didTapAction(item: HomeActionsSection.Action) {
        switch item.type {
        case .wallet:
            appCoordinator.executeCommand(HomeDashboardCoordinator.OpenWalletCommand())
        case .homeGuide:
            appCoordinator.executeCommand(HomeDashboardCoordinator.OpenHomeComingGuideCommand())
        default : break
        }
    }
}

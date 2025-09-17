//
//  HomePlannerViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.3.25.
//

import Observation
import SwiftUI

protocol HomePlannerViewModelProtocol {
    var homePlanner: HomePlannerPreviewSection { get }

    func didTapPlannerPreview()
}

@Observable
class HomePlannerViewModel: BaseViewModel, HomePlannerViewModelProtocol {
    var homePlanner: HomePlannerPreviewSection
    
    init(homePlanner: HomePlannerPreviewSection = HomePlannerPreviewSection.sample()) {
        self.homePlanner = homePlanner
    }
        
    func didTapPlannerPreview() {
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
    }
}

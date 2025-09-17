//
//  HomeSwitchVoyageViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Observation
import SwiftUI

protocol HomeSwitchVoyageViewModelProtocol {
    var homeSwitchVoyage: HomeSwitchVoyageSection { get }
    var sailingMode: SailingMode { get }

    func didTapNextAdventure()
    func didTapSwitchVoyages()
}

@Observable
class HomeSwitchVoyageViewModel: BaseViewModel, HomeSwitchVoyageViewModelProtocol {
    var homeSwitchVoyage: HomeSwitchVoyageSection
    var sailingMode: SailingMode
    
    init(homeSwitchVoyage: HomeSwitchVoyageSection = HomeSwitchVoyageSection.empty(),
         sailingMode: SailingMode) {
        self.homeSwitchVoyage = homeSwitchVoyage
        self.sailingMode = sailingMode
    }
    
    func didTapNextAdventure() {
        let urlString: String = "https://www.virginvoyages.com"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func didTapSwitchVoyages() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenSwitchVoyageCommand())
    }
}


//
//  HomeAddOnsPromoViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 18.3.25.
//

import Observation
import SwiftUI

protocol HomeAddOnsPromoViewModelProtocol {
    var homeAddOnsPromo: HomeAddOnsPromoSection { get }

    func didTapAddOns()
}

@Observable
class HomeAddOnsPromoViewModel: BaseViewModel, HomeAddOnsPromoViewModelProtocol {
 
    private var appCoordinator: AppCoordinator = .shared
    var homeAddOnsPromo: HomeAddOnsPromoSection
    
    init(homeAddOnsPromo: HomeAddOnsPromoSection = HomeAddOnsPromoSection.empty()) {
        self.homeAddOnsPromo = homeAddOnsPromo
    }
        
    func didTapAddOns() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonsListCommand())
    }
}

//
//  ServiceCoordinator.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/23/25.
//

import Foundation

enum ServiceNavigationRoute: BaseNavigationRoute {
    case cabinService
	case cabinServiceOpeningTime
    case cabinServiceOption(cabinServiceItem: CabinService.CabinServiceItem)
    case cabinServiceConfirmation(cabinServiceItem: CabinService.CabinServiceItem,
                                  isMaintenance: Bool,
                                  optionId: String?)
    case maintenanceService(cabinServiceItem: CabinService.CabinServiceItem)
    case helpAndSupport
    case helpAndSupportArticle(article: HelpAndSupport.Article)
    case shipEats
    case shipEatsOpeningTime
}

@Observable class ServiceCoordinator {
    
    var navigationRouter: NavigationRouter<ServiceNavigationRoute>
    
    init(navigationRouter: NavigationRouter<ServiceNavigationRoute> = .init()) {
        self.navigationRouter = navigationRouter
    }
    
}

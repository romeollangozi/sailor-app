//
//  ServicesLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/23/25.
//

import Foundation
import SwiftUI



@Observable class ServicesLandingScreenViewModel: BaseViewModel, ServicesLandingScreenViewModelProtocol {
    
    var appCoordinator: AppCoordinator
    
    init(appCoordinator: AppCoordinator = .shared) {
        self.appCoordinator = appCoordinator
    }
    
    private var navigationRouter: NavigationRouter<ServiceNavigationRoute> {
        return AppCoordinator.shared.homeTabBarCoordinator.serviceCoordinator.navigationRouter
    }
    
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        
        guard let serviceNavigationRoute = navigationRoute as? ServiceNavigationRoute else { return AnyView(Text("View not supported")) }
        
        switch serviceNavigationRoute {
        case .cabinService:
            return AnyView (
                CabinServicesScreen()
            )
        case .cabinServiceOption(let cabinServiceItem):
            return AnyView (
                CabinServiceOptionScreen(cabinServiceItem: cabinServiceItem)
            )
        case .cabinServiceConfirmation(cabinServiceItem: let cabinServiceItem,
                                       isMaintenance: let isMaintenance,
                                       optionId: let optionId):
            return AnyView (
                CabinServiceConfirmationScreen(cabinServiceItem: cabinServiceItem,
                                               isMaintenance: isMaintenance,
                                               optionId: optionId)
            )
        case .maintenanceService(cabinServiceItem: let cabinServiceItem):
            return AnyView (
                MaintenanceServiceScreen(cabinServiceItem: cabinServiceItem)
            )
        case .helpAndSupport:
            return AnyView (
                HelpAndSupportScreen()
            )
        case .helpAndSupportArticle(let article):
            return AnyView (
				HelpAndSupportArticleScreen(article: article)
            )
		case .cabinServiceOpeningTime:
			return AnyView (
				CabinServiceOpeningTimeScreen()
			)
        case .shipEats:
			let data = ToDoScreenData(title: "ShipEats",
									  message: "Hungry?",
									  alternativeMessage: "We’re still putting the finishing touches on this feature. Until then, your cabin tablet has everything you need.",
									  actionTitle: "",
									  deepLink: nil)
			let toDoViewModel = ToDoViewModel(data: data)
            return AnyView (
				VVToDoView(viewModel: toDoViewModel)
            )
        case .shipEatsOpeningTime:
            return AnyView (
                ShipEatsOpeningTimeScreen()
            )
        }
    }
    
    func goToRoot() {
        navigationRouter.goToRoot()
    }
}

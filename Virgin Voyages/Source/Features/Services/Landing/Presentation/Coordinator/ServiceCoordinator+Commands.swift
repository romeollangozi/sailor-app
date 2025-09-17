//
//  ServiceCoordinator+Commands.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/23/25.
//

import Foundation

extension ServiceCoordinator {
    
    struct ServiceBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateBack()
        }
    }
    
    struct CabinServiceCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.cabinService)
        }
    }
	
	struct CabinServiceOpeningTimeCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.cabinServiceOpeningTime)
		}
	}
    
    struct ShipEatsCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.shipEats)
        }
    }
    
    struct ShipEatsOpeningTimeCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.shipEatsOpeningTime)
        }
    }
    
    struct CabinOptionCommand: NavigationCommandProtocol {
        
        let cabinServiceItem: CabinService.CabinServiceItem
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.cabinServiceOption(cabinServiceItem: cabinServiceItem))
        }
    }
    
    struct CabinServiceConfirmationCommand: NavigationCommandProtocol {
        
        let cabinServiceItem: CabinService.CabinServiceItem
        let isMaintenance: Bool
        let optionId: String?
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.cabinServiceConfirmation(cabinServiceItem: cabinServiceItem,
                                                                                                                       isMaintenance: isMaintenance, optionId: optionId))
        }
    }
    
    struct MaintenanceConfirmationCommand: NavigationCommandProtocol {
        
        let cabinServiceItem: CabinService.CabinServiceItem
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.maintenanceService(cabinServiceItem: cabinServiceItem))
        }
        
    }
    
    struct HelpAndSupportCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.helpAndSupport)
        }
    }
    
    struct HelpAndSupportArticleCommand: NavigationCommandProtocol {
        let article: HelpAndSupport.Article
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.serviceCoordinator.navigationRouter.navigateTo(.helpAndSupportArticle(article: article))
        }
    }
    
}

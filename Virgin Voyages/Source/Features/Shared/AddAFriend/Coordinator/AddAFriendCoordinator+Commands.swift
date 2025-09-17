//
//  AddAFriendCoordinator+Commands.swift
//  Virgin Voyages
//
//  Created by TX on 24.2.25.
//

import Foundation

extension AddAFriendCoordinator {
    
    struct OpenSailorDetailsCommand: NavigationCommandProtocol {
        let sailorMateLink: String
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.addAFriendCoordinator.navigationRouter.navigateTo(.contactDetails(sailorMateLink: sailorMateLink))
        }
    }

    struct ShowCameraScanFullScreenCoverCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.addAFriendCoordinator.fullScreenRouter = .scanCode
        }
    }
    
    struct DismissFullScreenCoverCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.addAFriendCoordinator.fullScreenRouter = nil
        }
    }
    
    struct DismissAddFriendSheetIfVisibleCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            
            // Remove sheet from messenger coordinator if messengerCoordinator.sheetRouter.currentSheet is .addAFriend
            switch coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.currentSheet {
            case .addAFriend:
                coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.currentSheet = nil
            default: break
            }
            
            // remove from home tabbar
            if coordinator.homeTabBarCoordinator.sheetRouter.currentSheet == .addAFriend {
                coordinator.homeTabBarCoordinator.sheetRouter.currentSheet = nil
            }
        }
    }
    
    struct ResetNavigationRouteCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.addAFriendCoordinator.navigationRouter.goToRoot(animation: false)
        }
    }

}


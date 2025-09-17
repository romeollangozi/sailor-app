//
//  MessengerCoordinator+Commands.swift
//  Virgin Voyages
//
//  Created by TX on 24.2.25.
//

import Foundation

extension MessengerCoordinator {
    struct MessengerScreenGoBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
        }
    }
    
    struct DismissCurrentSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.currentSheet = nil
        }
    }
    
    struct ShowAddFriendSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.currentSheet = .addAFriend(.landing)
        }
    }
    
    struct ShowMyQRCodeSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.currentSheet = .myQRCode
        }
    }

    struct OpenContactDetailsPage: NavigationCommandProtocol {
        let sailorMate: MessengerContactsModel.ContactItemModel
        let deepLink: String
        let isSailorMate: Bool
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateTo(.contactDetails(contactItem: sailorMate, deepLink: deepLink, isSailorMate: isSailorMate))
        }
    }
    
    struct OpenChatThreadsCommand: NavigationCommandProtocol {
        let chatThread: ChatThread
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateTo(.chatThread(chatThread: chatThread))
        }
    }

	struct OpenChatThreadsFromMeSectionCommand: NavigationCommandProtocol {
		let chatThread: ChatThread
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.selectedTab = .messenger
			coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateTo(.chatThread(chatThread: chatThread))
		}
	}
}

//
//  MessengerCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 11.2.25.
//

import Foundation
import SwiftUI

enum MessengerNavigationRoute: BaseNavigationRoute {
	case contactList
    case contacts(link: String?)
    case contactDetails(contactItem: MessengerContactsModel.ContactItemModel, deepLink: String, isSailorMate: Bool)
	case chatThread(chatThread: ChatThread)
}


enum MessengerSheetRoute: BaseSheetRouter {
    case addAFriend(AddAFriendNavigationRoute)
    case myQRCode
    case addAFriendFromDeepLink(contact: AddContactData)

    var id: String {
        switch self {
        case .addAFriend:
            return "addAFriend"
        case .addAFriendFromDeepLink:
            return "addAFriendFromDeepLink"
        case .myQRCode:
            return "myQRCode"
        }
    }
}


@Observable class MessengerCoordinator {
    var navigationRouter: NavigationRouter<MessengerNavigationRoute>
    var sheetRouter: SheetRouter<MessengerSheetRoute>

    init(navigationRouter: NavigationRouter<MessengerNavigationRoute> = .init(), sheetRouter: SheetRouter<MessengerSheetRoute> = .init()) {
        self.navigationRouter = navigationRouter
        self.sheetRouter = sheetRouter
    }
}

//
//  AddAFriendCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 24.2.25.
//

import Foundation

enum AddAFriendNavigationRoute: BaseNavigationRoute {
    case landing
    case contactDetails(sailorMateLink: String)
    case confirmAddContact(sailorMateLink: String)
}

enum AddAFriendFullScreenRoute: BaseFullScreenRoute {
    case scanCode
    var id: String {
        switch self {
        case .scanCode:
            return "scannContact"
        }
    }
}

@Observable class AddAFriendCoordinator {
    var navigationRouter: NavigationRouter<AddAFriendNavigationRoute>
    var fullScreenRouter: AddAFriendFullScreenRoute?
    
    init(
        navigationRouter: NavigationRouter<AddAFriendNavigationRoute> = .init(),
        fullScreenRouter: AddAFriendFullScreenRoute? = nil
    ) {
        self.navigationRouter = navigationRouter
        self.fullScreenRouter = fullScreenRouter
    }
}

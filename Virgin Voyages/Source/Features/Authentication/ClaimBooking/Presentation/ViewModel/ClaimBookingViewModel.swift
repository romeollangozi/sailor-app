//
//  ClaimBookingViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import Foundation
import SwiftUI

@Observable class ClaimBookingViewModel {
    var appCoordinator: CoordinatorProtocol
    let shouldShowCloseFlowButton: Bool
    private let rootPath: ClaimABookingNavigationRoute?
    
    var initialRoute: ClaimABookingNavigationRoute {
        return rootPath ?? .landing // If no root path is declared, use landing page as default
    }
    
    init(shouldShowCloseFlowButton: Bool = false, rootPath: ClaimABookingNavigationRoute?, appCoordinator: CoordinatorProtocol = AppCoordinator.shared) {
        self.appCoordinator = appCoordinator
        self.shouldShowCloseFlowButton = shouldShowCloseFlowButton
        self.rootPath = rootPath
    }
    
}

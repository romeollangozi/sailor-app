//
//  HomeMusterDrillViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

@Observable class HomeMusterDrillViewModel: BaseViewModel, HomeMusterDrillViewModelProtocol {
    
    private let musterDrillSection: HomeMusterDrillSection
    private let appCoordinator: CoordinatorProtocol
    
    init(musterDrillSection: HomeMusterDrillSection = .empty(),
         appCoordinator: CoordinatorProtocol = AppCoordinator.shared) {
        self.musterDrillSection = musterDrillSection
        self.appCoordinator = appCoordinator
    }
    
    var backgroundImage: String {
        musterDrillSection.backgroundImageUrl
    }
    
    var title: String {
        musterDrillSection.title
    }
    
    var actionText: String {
        musterDrillSection.description
    }
    
    func onViewTap() {
        // display muster mode
        self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowMusterDrillFullScreenCommand(shouldRemainOpenAfterUserHasWatchedSafteyVideo: true))
    }
}

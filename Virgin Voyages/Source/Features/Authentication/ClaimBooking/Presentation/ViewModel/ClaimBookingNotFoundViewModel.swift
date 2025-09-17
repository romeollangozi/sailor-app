//
//  ClaimABookingNotFountViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 22.1.25.
//

import Foundation

@Observable class ClaimBookingNotFoundViewModel: ClaimBookingNotFoundViewModelProtocol {
    private var appCoordinator: CoordinatorProtocol

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Navigation
    func navigateBack() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackCommand())
    }
    
    func navigateBackToRoot() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackToRootViewCommand())
    }
    
    func enterDetailsManuallyButtonTapped() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenManualEntryView())
    }
}

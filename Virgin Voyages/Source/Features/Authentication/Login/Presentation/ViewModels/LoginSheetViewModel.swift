//
//  LoginSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import SwiftUI

protocol LoginSheetViewModelProtocol: BaseViewModelProtocol {
    func dismissAndShowDeactivatedAccountSheet()
    func dismissView()
    func dismissFullScreenModal()
	func dismissErrorModalAndGoBack()
}

@Observable class LoginSheetViewModel: BaseViewModelV2, LoginSheetViewModelProtocol {

    // MARK: Navigation
    func dismissAndShowDeactivatedAccountSheet() {
		navigationCoordinator.executeCommand(LandingScreensCoordinator.OpenClaimABookingDeactivatedAccountScreenCommand())
    }
    
    func dismissView() {
		navigationCoordinator.landingScreenCoordinator.dismissCurrentSheet()
    }
    
    func dismissFullScreenModal() {
		navigationCoordinator.executeCommand(LoginSelectionCoordinator.DismissFullScreenCommand())
    }
        
    func dismissErrorModalAndGoBack() {
		navigationCoordinator.executeCommand(LoginSelectionCoordinator.DismissErrorModalAndGoBack())
    }
}

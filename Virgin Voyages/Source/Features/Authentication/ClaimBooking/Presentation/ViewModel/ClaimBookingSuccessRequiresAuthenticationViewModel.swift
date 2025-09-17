//
//  ClaimBookingSuccessRequiresAuthenticationViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/4/24.
//

import Foundation

@Observable class ClaimBookingSuccessRequiresAuthenticationViewModel: BaseViewModel {

	private var logoutUserUseCase: LogoutUserUseCaseProtocol

    init(logoutUserUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase()) {
		self.logoutUserUseCase = logoutUserUseCase
    }

    func login() {
        Task {
			await logoutUserUseCase.execute()
        }
        openLoginWithEmail()
    }

    func openLoginWithEmail() {
		navigationCoordinator.executeCommand(LandingScreensCoordinator.DismissCurrentSheetAndOpenLoginCommand())
    }
}

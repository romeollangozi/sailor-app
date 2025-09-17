//
//  ProfileReservationCoreErrorViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 27.8.25.
//

import VVUIKit
import UIKit

@MainActor
@Observable final class ProfileReservationCoreErrorViewModel: BaseViewModelV2, ExceptionViewModelProtocol {
    
    private let localizationManager: LocalizationManagerProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let logoutUserUseCase: LogoutUserUseCaseProtocol

    private var isReloading: Bool = false
    private var reloadAttemptCount: Int = 0
    private var maxAttemptCount: Int = 1

    init(
        localizationManager: LocalizationManagerProtocol = LocalizationManager.shared,
        authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
        logoutUserUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase()
    ) {
        self.localizationManager = localizationManager
        self.authenticationService = authenticationService
        self.logoutUserUseCase = logoutUserUseCase
		super.init()
		onAppear()
	}
    
    private var error: AuthenticationServiceError? {
        authenticationService.error
    }

    // MARK: - ExceptionViewModelProtocol Implementation
    
    var shouldAllowReload: Bool {
        reloadAttemptCount < maxAttemptCount
    }
    
    var primaryButtonIsLoading: Bool {
        isReloading
    }
    
    var exceptionTitle: String  {
        if shouldAllowReload {
            localizationManager.getString(for: .apiErrorStateWeAreSorryTitle)
        } else {
            localizationManager.getString(for: .apiErrorStateTroubleLoadingTitle)
        }
    }
    
    var secondaryButtonText: String {
        if shouldAllowReload {
            ""
        } else {
            localizationManager.getString(for: .globalContactSupportCta)
        }
    }
    
    

    
    var exceptionDescription: String {
        if shouldAllowReload {
            localizationManager.getString(for: .apiErrorStateTroubleLoadingBody)
        } else {
            localizationManager.getString(for: .apiErrorStateWeAreSorryBody)
        }
    }
    

    var primaryButtonText: String {
        if shouldAllowReload {
            "Try again" // API issue - We don't have the string in the cms yet
        } else {
            localizationManager.getString(for: .apiErrorStateLogout)
        }
    }
    
    var imageName: String = "exception_server_error"
    var exceptionLayout: ExceptionLayout = .withLinkButton
    var primaryButtonAction: ExceptionButtonAction = .primaryButtonAction
    var secondaryButtonAction: ExceptionButtonAction = .secondaryButtonAction

	// MARK: - Protocol Methods
	func onAppear() {
	}

	func onPrimaryButtonTapped() {
        if shouldAllowReload {
            reload()
        } else {
            logout()
        }
	}

	func onSecondaryButtonTapped() {
        let helpPortalURL = "https://help.virginvoyages.com/helpportal/s/contactus"
        if let url = URL(string: helpPortalURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Private methods
    
    private func reload() {
        isReloading = true
        reloadAttemptCount += 1
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.authenticationService.reloadReservation(reservationNumber: nil, displayLoadingFlow: false)
                isReloading = false
            } catch {
                isReloading = false
            }
        }
    }
    
    private func logout(){
        Task { [weak self] in
            guard let self else { return }
            await self.logoutUserUseCase.execute()
        }
    }

}


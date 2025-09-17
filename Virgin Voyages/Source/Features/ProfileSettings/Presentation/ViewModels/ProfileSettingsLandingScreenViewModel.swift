//
//  ProfileSettingsLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import Foundation
import UIKit

protocol ProfileSettingsLandingScreenViewModelProtocol {
    var landingScreenModel: ProfileSettingsLandingScreenModel { get set }
    var screenState: ScreenState { get set }
    var shouldShowLogoutConfirmation: Bool { get set }

    func logout()
    func refresh() async
	func onDeleteAcconutTap()
}

@Observable class ProfileSettingsLandingScreenViewModel: ProfileSettingsLandingScreenViewModelProtocol {
    var screenState: ScreenState = .loading
    var shouldShowLogoutConfirmation: Bool = false
    var landingScreenModel: ProfileSettingsLandingScreenModel = .init(content: ProfileSettingsLandingScreenModel.ContentModel(screenTitle: "", screenDescription: "", imageUrl: ""), menuItems: [])
    
    private var getProfileSettingsLandingScreenUseCase: GetProfileSettingsLandingScreenUseCaseProtocol
    private var logoutUseCase: LogoutUserUseCaseProtocol
    private var webUrlLauncher: WebUrlLauncherProtocol
    
    init(
        getProfileSettingsLandingScreenUseCase: GetProfileSettingsLandingScreenUseCaseProtocol = GetProfileSettingsLandingScreenUseCase(),
        logoutUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase(),
		webUrlLauncher: WebUrlLauncherProtocol = WebUrlLauncher()
    ) {
        self.getProfileSettingsLandingScreenUseCase = getProfileSettingsLandingScreenUseCase
        self.logoutUseCase = logoutUseCase
		self.webUrlLauncher = webUrlLauncher
    }
    
    // MARK: Public API
    
    func refresh() async {
        if screenState == .content { return }
        screenState = .loading
        let result = await getProfileSettingsLandingScreenUseCase.execute()
        switch result {
        case .success(let content):
            finishLoading(with: .content, content: content)
        case .failure(let failure):
            print("Error - failure : ", failure.localizedDescription)
            finishLoading(with: .error, content: landingScreenModel)
        }
    }
    
    func showLogOutConfirmation() {
        shouldShowLogoutConfirmation.toggle()
    }

    func logout() {
		Task {
			await self.logoutUseCase.execute()
		}
    }
	
	func onDeleteAcconutTap() {
		if let url = URL(string: "https://virginvoyages.my.salesforce-sites.com/submitaccountdelete") {
			webUrlLauncher.open(url: url)
		}
	}
    
    // MARK: Private Methods
    private func finishLoading(with state: ScreenState, content: ProfileSettingsLandingScreenModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.landingScreenModel = content
            self.screenState = state
        }
    }
}

//
//  CancelledVoyageExceptionViewModel..swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.8.25.
//

import SwiftUI
import VVUIKit
import Observation

@Observable final class CancelledVoyageExceptionViewModel: BaseViewModel, ExceptionViewModelProtocol {
	// MARK: - Properties
	var exceptionTitle: String = ""
	var exceptionDescription: String = ""
	var primaryButtonText: String = ""
	var secondaryButtonText: String = ""
	var imageName: String = "exception_voyager_not_found"
    var primaryButtonIsLoading: Bool = false
	var exceptionLayout: ExceptionLayout = .withLinkButton
	var primaryButtonAction: ExceptionButtonAction = .primaryButtonAction
	var secondaryButtonAction: ExceptionButtonAction = .secondaryButtonAction

	private let localizationManager: LocalizationManager

	init(localizationManager: LocalizationManager = .shared) {
		self.localizationManager = localizationManager
		super.init()
		onAppear()
	}

	// MARK: - Protocol Methods
	func onAppear() {
		exceptionTitle = localizationManager.getString(for: .voyageCancelledTitle)
		exceptionDescription = localizationManager.getString(for: .voyageCancelledDescription)
		primaryButtonText = localizationManager.getString(for: .okGotIt)
		secondaryButtonText = localizationManager.getString(for: .contactSailorServiceButtonText)
	}

	func onPrimaryButtonTapped() {
		navigationCoordinator.executeCommand(ClaimABookingCoordinator.OpenLandingViewCommand())
	}

	func onSecondaryButtonTapped() {
		let helpPortalURL = "https://help.virginvoyages.com/helpportal/s/contactus"
		if let url = URL(string: helpPortalURL) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
}

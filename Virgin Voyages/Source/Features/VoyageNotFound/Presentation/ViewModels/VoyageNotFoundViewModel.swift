//
//  VoyageNotFoundViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 12.8.25.
//


import SwiftUI
import VVUIKit
import Observation

@Observable final class VoyageNotFoundViewModel: BaseViewModel, ExceptionViewModelProtocol {

	// MARK: - Properties
	var exceptionTitle: String = ""
	var exceptionDescription: String = ""
	var primaryButtonText: String = ""
	var secondaryButtonText: String = ""
    var primaryButtonIsLoading: Bool = false
	var imageName: String = "exception_voyager_not_found"
	var exceptionLayout: ExceptionLayout = .defaultLayout
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
		exceptionTitle = localizationManager.getString(for: .voyageNotFoundTitle)
		exceptionDescription = localizationManager.getString(for: .voyageNotFoundBody)
		primaryButtonText = localizationManager.getString(for: .contactSailorServiceButtonText)
	}

	func onPrimaryButtonTapped() {
		let helpPortalURL = "https://help.virginvoyages.com/helpportal/s/contactus"
		if let url = URL(string: helpPortalURL) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}

	func onSecondaryButtonTapped() {}
}

//
//  DeepLinkService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/20/25.
//

import UIKit

class DeepLinkService: DeepLinkServiceProtocol {

	func openReactNativeApp() {
		let appURLString = "com.virginvoyages.sailorapp://"
		let appStoreURLString = "https://apps.apple.com/in/app/virgin-voyages/id1478112097"
		let application = UIApplication.shared

		if let appURL = URL(string: appURLString), application.canOpenURL(appURL) {
			application.open(appURL, options: [:], completionHandler: nil)
			return
		}

		if let appStoreURL = URL(string: appStoreURLString) {
			UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
		}
	}
}

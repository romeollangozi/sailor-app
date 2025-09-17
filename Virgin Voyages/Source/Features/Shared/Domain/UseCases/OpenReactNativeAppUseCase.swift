//
//  OpenReactNativeAppUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/20/25.
//

import Foundation

protocol OpenReactNativeAppUseCaseProtocol {
	func execute()
}

class OpenReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol {

	private var deepLinkService: DeepLinkServiceProtocol

	init(deepLinkService: DeepLinkServiceProtocol = DeepLinkService()) {
		self.deepLinkService = deepLinkService
	}

	func execute() {
		deepLinkService.openReactNativeApp()
	}
}

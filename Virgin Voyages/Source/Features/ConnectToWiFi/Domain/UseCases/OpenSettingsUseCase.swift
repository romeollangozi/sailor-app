//
//  OpenSettingsUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/4/25.
//


import UIKit

class OpenSettingsUseCase {
	private let urlOpener: URLOpener

	init(urlOpener: URLOpener = DefaultURLOpener()) {
		self.urlOpener = urlOpener
	}

	func execute() {
		if let url = URL(string: UIApplication.openSettingsURLString) {
			urlOpener.open(url)
		}
	}
}

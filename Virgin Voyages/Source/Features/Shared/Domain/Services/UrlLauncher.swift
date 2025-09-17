//
//  UrlLauncher.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.5.25.
//

import Foundation
import UIKit

protocol WebUrlLauncherProtocol {
	func open(url: URL)
}

final class WebUrlLauncher: WebUrlLauncherProtocol {
	func open(url: URL) {
		UIApplication.shared.open(url)
	}
}

//
//  MockWebUrlLauncher.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.5.25.
//


import Foundation
@testable import Virgin_Voyages

final class MockWebUrlLauncher: WebUrlLauncherProtocol {
	var lastOpenedUrl: URL? = nil
	
	func open(url: URL) {
		lastOpenedUrl = url
	}
}


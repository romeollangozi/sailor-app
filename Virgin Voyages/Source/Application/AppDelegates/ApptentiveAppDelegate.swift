//
//  ApptentiveAppDelegate.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/20/25.
//

import SwiftUI
import Foundation
import ApptentiveKit

class ApptentiveAppDelegate: NSObject, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		configureApptentive()
		return true
	}

    func configureApptentive() {
        ApptentiveService.shared.registerIfNeeded()
    }
}

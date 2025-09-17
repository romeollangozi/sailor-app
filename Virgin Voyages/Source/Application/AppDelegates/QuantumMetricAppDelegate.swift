//
//  QuantumMetricAppDelegate.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.2.25.
//

import Foundation
import UIKit
import QMNative

class QuantumMetricAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configureQuantumMetric()
        return true
    }
    
    func configureQuantumMetric() {
        QMNative.initialize(withSubscription: "virginvoyages", uid: "5f7e5b13-c5fe-423d-9393-6808e07692a4")
        QMNative.enableTestConfig(true)
		QMNative.disableCrashReporting()
    }
}

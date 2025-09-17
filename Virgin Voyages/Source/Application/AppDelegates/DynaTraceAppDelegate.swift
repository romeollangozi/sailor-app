//
//  DynaTraceAppDelegate 2.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.12.24.
//


import Foundation
import UIKit
import Dynatrace

class DynaTraceAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configureDynaTrace()
        return true
    }
    
    func configureDynaTrace() {
        VVAnalyticsService.shared.configure(with: [DynaTraceAnalyticsService.shared])
    }
}

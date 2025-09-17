//
//  DynaTraceAnalyticsService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.12.24.
//


import Foundation
import Dynatrace

class DynaTraceAnalyticsService: AnalyticsServiceProtocol {
    static let shared = DynaTraceAnalyticsService()
    
    private init() {}
    
    func logEvent(event: AnalyticsEvent) {
        let (name, attributes) = event.details
        guard let action = DTXAction.enter(withName: name) else { return }
        attributes?.forEach { key, value in
            action.reportValue(withName: "\(value)", stringValue: key)
        }

        action.reportEvent(withName: name)
        action.leave()
    }
    
    func logError(error: AnalyticsError) {
        let (name, message, attributes) = error.details
        guard let action = DTXAction.enter(withName: name) else { return }
        let errorInfo = NSError(domain: "DynatraceError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
        action.reportError(withName: name, error: errorInfo)
        attributes?.forEach { key, value in
            action.reportValue(withName: "\(value)", stringValue: key)
        }
        action.leave()
    }
}

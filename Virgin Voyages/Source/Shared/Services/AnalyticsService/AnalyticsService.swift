//
//  AnalyticsService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.12.24.
//

import Dynatrace
import Foundation

protocol AnalyticsServiceProtocol {
    func logEvent(event: AnalyticsEvent)
    func logError(error: AnalyticsError)
}

class VVAnalyticsService: AnalyticsServiceProtocol {

    static let shared = VVAnalyticsService()
    private var services: [AnalyticsServiceProtocol]
    
    private init(services: [AnalyticsServiceProtocol] = [DynaTraceAnalyticsService.shared]) {
        self.services = services
    }

    func configure(with services: [AnalyticsServiceProtocol]) {
        self.services = services
    }

    func logEvent(event: AnalyticsEvent) {
        let (name, attributes) = event.details
        services.forEach { $0.logEvent(event: .customEvent(name: name, attributes: attributes)) }
    }

    func logError(error: AnalyticsError) {
        let (name, message, attributes) = error.details
        services.forEach { $0.logError(error: .customError(name: name, message: message, attributes: attributes))}
    }
}

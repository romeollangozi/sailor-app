//
//  QuantumMetricService.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.2.25.
//

import Foundation
import QMNative

protocol QuantumMetricServiceProtocol {
    func trackEvent(event: QMTrackEvent)
    func trackError(error: QMTrackError)
}


class QuantumMetricService: QuantumMetricServiceProtocol {
    
    func trackEvent(event: QMTrackEvent) {
        QMNative.sendEvent(withID: event.details.id, value: event.details.value)
    }
    
    func trackError(error: QMTrackError) {
        QMNative.sendError(withID: error.details.id, value: error.details.value)
    }
}

extension QuantumMetricService {

    static func create() -> QuantumMetricServiceProtocol {
        return QuantumMetricService()
    }
}

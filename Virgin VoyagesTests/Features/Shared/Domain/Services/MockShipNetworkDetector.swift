//
//  MockShipNetworkDetector.swift
//  Virgin Voyages
//
//  Created by TX on 6.8.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockShipNetworkDetector: ShipNetworkDetectorProtocol {
    var isReachable: Bool = false
    func isShipNetworkReachable() async -> Bool {
        return isReachable
    }
}

//
//  MockShipTimeService.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 8.5.25.
//

import XCTest

@testable import Virgin_Voyages

class MockShipTimeService: ShipTimeServiceProtocol {
    var expectedDate: Date?
    func fetchShipTime() async -> Date? {
        return expectedDate
    }
    func syncShipTime() async { }
}

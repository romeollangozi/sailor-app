//
//  MockDateTimeRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.5.25.
//

import XCTest

@testable import Virgin_Voyages

class MockDateTimeRepository: DateTimeRepositoryProtocol {
    var mockShipTime: Date? = nil
    var mockDeviceTime: Date = Date()
    
    func fetchDateTime() async -> DateTime {
        return DateTime(deviceTime: mockDeviceTime, shipTime: mockShipTime)
    }
}

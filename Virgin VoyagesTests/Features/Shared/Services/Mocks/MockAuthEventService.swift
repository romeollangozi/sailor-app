//
//  MockAuthEventService.swift
//  Virgin Voyages
//
//  Created by TX on 27.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockAuthEventService: AuthenticationEventNotificationService {

    private(set) var published: [AuthenticationEventNotification] = []
    var publishExpectation: XCTestExpectation?

    // If DomainNotificationService.publish is not open, remove "override" and rely on base behavior
    override func publish(_ event: AuthenticationEventNotification) {
        published.append(event)
        publishExpectation?.fulfill()
        super.publish(event)
    }

    func reset() {
        published.removeAll()
        publishExpectation = nil
    }
}


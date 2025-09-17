//
//  MockDeepLinkNotificationDispatcher.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockDeepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol {
    
    var didDispatchCount = 0
    
    func dispatch(userStatus: Virgin_Voyages.UserApplicationStatus, type: String, data: String) {
        didDispatchCount += 1
    }
}

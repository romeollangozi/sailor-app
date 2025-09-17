//
//  DashboardLandingRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by TX on 20.3.25.
//

import Foundation
@testable import Virgin_Voyages

class MockDashboardLandingRepository: DashboardLandingRepositoryProtocol {
    var shouldThrowError = false
    var errorToThrow: Error?
    var mockTaskDetail: TaskDetail?

    func fetchDashboardLanding(reservationNumber: String, guestId: String) async -> DashboardLanding? {
        if shouldThrowError {
            return nil
        }
        
        return DashboardLanding(
            taskList: TaskList(tasksDetail: mockTaskDetail != nil ? [mockTaskDetail!] : [])
        )
    }
}

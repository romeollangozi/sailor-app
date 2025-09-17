//
//  MockMotionDetectionService.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/27/25.
//

import Foundation
@testable import Virgin_Voyages

class MockMotionDetectionService: MotionDetectionServiceProtocol {
    var startMotionDetectionCalled = false
    var stopMotionDetectionCalled = false
    var startMotionDetectionCallCount = 0
    var stopMotionDetectionCallCount = 0
    
    func startMotionDetection() {
        startMotionDetectionCalled = true
        startMotionDetectionCallCount += 1
    }
    
    func stopMotionDetection() {
        stopMotionDetectionCalled = true
        stopMotionDetectionCallCount += 1
    }
    
}

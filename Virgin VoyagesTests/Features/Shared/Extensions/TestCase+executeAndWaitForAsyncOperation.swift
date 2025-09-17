//
//  TestCase+executeAndWaitForAsyncOperation.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.4.25.
//

import XCTest

extension XCTestCase {
	func executeAndWaitForAsyncOperation(timeout: TimeInterval = 5.0,
									 delay: TimeInterval = 1, operation: @escaping () -> Void) {
		let expectation = XCTestExpectation(description: "Wait for async operations")
		
		operation()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: timeout)
	}
}

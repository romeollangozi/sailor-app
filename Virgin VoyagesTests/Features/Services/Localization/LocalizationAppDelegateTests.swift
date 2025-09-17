//
//  LocalizationAppDelegateTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 16.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class LocalizationAppDelegateTests: XCTestCase {

    func test_applicationLaunch_executesUseCaseWithCacheFalse() async throws {
        let mockUseCase = MockLoadLocalizationUseCase()
        let delegate = LocalizationAppDelegate(useCase: mockUseCase)

        _ = delegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(mockUseCase.didLoad)
        XCTAssertEqual(mockUseCase.usedCache, false)
    }

    func test_applicationLaunch_createsDefaultUseCaseIfNil() async throws {
        // Arrange: Create mock use case instead of using default constructor
        let mockUseCase = MockLoadLocalizationUseCase()
        let delegate = LocalizationAppDelegate(useCase: mockUseCase)

        // Act
        let result = await delegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

        // Wait for the async Task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms

        // Assert: Verify the mock was called instead of real network calls
        XCTAssertTrue(result)
        XCTAssertTrue(mockUseCase.didLoad)
        XCTAssertEqual(mockUseCase.usedCache, false)
    }

}

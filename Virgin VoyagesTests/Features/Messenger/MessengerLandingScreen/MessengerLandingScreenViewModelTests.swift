//
//  MessengerLandingScreenViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Timur Xhabiri on 28.10.24.
//

import XCTest
@testable import Virgin_Voyages

// MARK: - MessengerLandingScreenViewModel Tests
final class MessengerLandingScreenViewModelTests: XCTestCase {
    
    var viewModel: MessengerLandingScreenViewModel!
    var mockUseCase: MockMessengerLandingScreensUseCase!
    
    @MainActor override func setUp() {
        super.setUp()
        
        // Initialize mock dependencies
        mockUseCase = MockMessengerLandingScreensUseCase()
        
        // Initialize view model with mock use case
        viewModel = MessengerLandingScreenViewModel(messengerLandingScreenUseCase: mockUseCase)
    }

    @MainActor override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func testRefreshSetsStateToContentOnSuccess() async {
        // Given
        let mockContent = MessengerLandingScreenModel.mock()
        mockUseCase.result = .success(mockContent)
        let expectation = XCTestExpectation(description: "Async refresh completed")

        // When
        await viewModel.refresh()
        
        // Switch on main thread
        DispatchQueue.main.async {
            // Assert
            XCTAssertEqual(self.viewModel.screenState, .content)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)

    }
    
    func testRefreshSetsStateToErrorOnFailure() async {
        // Given
		mockUseCase.error = .failure(.unauthorized)
        let expectation = XCTestExpectation(description: "Async refresh completed")

        // When
        await viewModel.refresh()

        // Switch on main thread
        DispatchQueue.main.async {
            // Assert
            XCTAssertEqual(self.viewModel.screenState, .error)
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }
}


//
//  ShakeForChampagneCancellationConfitmationViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/13/25.
//

import Foundation

import XCTest
@testable import Virgin_Voyages

final class ShakeForChampagneCancellationConfitmationViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var viewModel: ShakeForChampagneCancellationConfitmationViewModel!
    private var mockShakeForChampagne: ShakeForChampagne!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        
        mockShakeForChampagne = ShakeForChampagne.sample()
        viewModel = ShakeForChampagneCancellationConfitmationViewModel(shakeForChampagne: mockShakeForChampagne, onCancelAction: nil)
    }
    
    override func tearDown() {
        
        mockShakeForChampagne = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testInitialization() {
        XCTAssertEqual(viewModel.screenState, .loading)
        XCTAssertNotNil(viewModel.shakeForChampagneCancellation)
        XCTAssertEqual(viewModel.shakeForChampagneCancellation, mockShakeForChampagne.cancellation)
    }
    
    func testOnAppear_SetsScreenStateToContent() {
        // Given
        viewModel.screenState = .loading
        
        // When
        viewModel.onAppear()
        
        // Then
        XCTAssertEqual(viewModel.screenState, .content)
    }
    
    func testOnRefresh_SetsScreenStateToContent() {
        // Given
        viewModel.screenState = .error
        
        // When
        viewModel.onRefresh()
        
        // Then
        XCTAssertEqual(viewModel.screenState, .content)
    }
    
    // MARK: - Screen State Transition Tests
    func testScreenStateTransitions() {
        // Given - starts with loading
        XCTAssertEqual(viewModel.screenState, .loading)
        
        // When onAppear is called
        viewModel.onAppear()
        
        // Then state changes to content
        XCTAssertEqual(viewModel.screenState, .content)
        
        // When state is manually changed to error
        viewModel.screenState = .error
        
        // When onRefresh is called
        viewModel.onRefresh()
        
        // Then state changes back to content
        XCTAssertEqual(viewModel.screenState, .content)
    }
    
}

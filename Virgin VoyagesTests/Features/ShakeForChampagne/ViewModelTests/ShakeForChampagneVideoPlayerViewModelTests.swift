//
//  ShakeForChampagneVideoPlayerViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 7/11/25.
//

import XCTest
@testable import Virgin_Voyages

final class ShakeForChampagneVideoPlayerViewModelTests: XCTestCase {
    
    var viewModel: ShakeForChampagneVideoPlayerViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ShakeForChampagneVideoPlayerViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_onAppear_initializesChampagneAnimationVideoPlayer() {
        // When
        viewModel.onAppear()
        
        // Then
        XCTAssertNotNil(viewModel.champagneAnimationVideoPlayer, "champagneAnimationVideoPlayer should be initialized")
    }
    
}

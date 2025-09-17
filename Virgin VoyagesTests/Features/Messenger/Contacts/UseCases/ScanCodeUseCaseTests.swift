//
//  ScanCodeUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.11.24.
//


import XCTest
@testable import Virgin_Voyages


final class ScanCodeUseCaseTests: XCTestCase {
    
    var useCase: ScanCodeUseCase!
    var mockLocalizationManager: MockLocalizationManager!
    
    override func setUp() {
        super.setUp()
        
        mockLocalizationManager = MockLocalizationManager(preloaded: [
            .messengerScaneHelpMeText: "Help me!",
            .messengerPositionCameraText: "Position sailor code within frame"
        ])

        useCase = ScanCodeUseCase(localizationManager: mockLocalizationManager)
    }
    
    override func tearDown() {
        useCase = nil
        mockLocalizationManager = nil
        
        super.tearDown()
    }
    
    func testExecute_ReturnsCorrectScannerViewModel() {
        // Act
        let result = useCase.execute()
        
        // Assert
        switch result {
        case .success(let viewModel):
            XCTAssertEqual(viewModel.helpMeText, "Help me!")
            XCTAssertEqual(viewModel.positionSailorCodeText, "Position sailor code within frame")
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
}


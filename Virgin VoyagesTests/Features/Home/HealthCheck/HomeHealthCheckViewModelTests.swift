//
//  HomeHealthCheckViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/3/25.
//

import XCTest
@testable import Virgin_Voyages

final class HomeHealthCheckViewModelTests: XCTestCase {
 
    var mockRepository: HomeHealthCheckRepositoryMock!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var useCase: GetHealthCheckUseCase!
    var viewModel: HealthCheckEntryPointViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = HomeHealthCheckRepositoryMock()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetHealthCheckUseCase(homeHealthCheckRepository: mockRepository,
                                            currentSailorManager: mockCurrentSailorManager)
        viewModel = HealthCheckEntryPointViewModel(homeHealthCheckUseCase: useCase)
    }
    
    override func tearDown() {
        mockRepository = nil
        mockCurrentSailorManager = nil
        useCase = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_OnAppear_SuccessfulLoad() async {
        
        let mockHomeHealthCheckDetail = HealthCheckDetail.sample()
        mockRepository.mockHealthCheckDetail = mockHomeHealthCheckDetail
        mockRepository.shouldThrowError = false
        
        executeAndWaitForAsyncOperation {
            self.viewModel.onAppear()
        }
        
        XCTAssertEqual(viewModel.homeHealthCheckDetail.isHealthCheckComplete, mockHomeHealthCheckDetail.isHealthCheckComplete)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.isFitToTravel, mockHomeHealthCheckDetail.isFitToTravel)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.updateURL, mockHomeHealthCheckDetail.updateURL)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.downloadContractFileUrl, mockHomeHealthCheckDetail.downloadContractFileUrl)
        
        XCTAssertEqual(viewModel.homeHealthCheckDetail.landingPage.title, mockHomeHealthCheckDetail.landingPage.title)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.landingPage.description, mockHomeHealthCheckDetail.landingPage.description)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.landingPage.imageURL, mockHomeHealthCheckDetail.landingPage.imageURL)
        
        XCTAssertEqual(viewModel.homeHealthCheckDetail.healthCheckRefusePage.title, mockHomeHealthCheckDetail.healthCheckRefusePage.title)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.healthCheckReviewPage.title, mockHomeHealthCheckDetail.healthCheckReviewPage.title)
        
        XCTAssertEqual(viewModel.homeHealthCheckDetail.landingPage.questionsPage.healthQuestions.count, mockHomeHealthCheckDetail.landingPage.questionsPage.healthQuestions.count)
        XCTAssertEqual(viewModel.homeHealthCheckDetail.landingPage.questionsPage.travelParty.partyMembers.count, mockHomeHealthCheckDetail.landingPage.questionsPage.travelParty.partyMembers.count)
    }
    
    func test_OnXButton_Tapped() {
        
        viewModel.dismissHealthCheck()
        
        XCTAssertEqual(viewModel.navigationCoordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter, nil)
    }
    
    
}

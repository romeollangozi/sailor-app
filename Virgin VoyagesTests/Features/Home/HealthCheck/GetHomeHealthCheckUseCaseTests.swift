//
//  GetHomeHealthCheckUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/3/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeHealthCheckUseCaseTests: XCTestCase {
    
    var mockRepository: HomeHealthCheckRepositoryMock!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var useCase: GetHealthCheckUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = HomeHealthCheckRepositoryMock()
        mockCurrentSailorManager = MockCurrentSailorManager()
        useCase = GetHealthCheckUseCase(homeHealthCheckRepository: mockRepository,
                                            currentSailorManager: mockCurrentSailorManager)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        mockCurrentSailorManager = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
       
        let mockHomeHealthCheckDetail = HealthCheckDetail.sample()
        mockRepository.mockHealthCheckDetail = mockHomeHealthCheckDetail
        
        let homeHealthCheckDetail = try await useCase.execute()
        
        XCTAssertEqual(homeHealthCheckDetail.isHealthCheckComplete, mockHomeHealthCheckDetail.isHealthCheckComplete)
        XCTAssertEqual(homeHealthCheckDetail.isFitToTravel, mockHomeHealthCheckDetail.isFitToTravel)
        XCTAssertEqual(homeHealthCheckDetail.updateURL, mockHomeHealthCheckDetail.updateURL)
        XCTAssertEqual(homeHealthCheckDetail.downloadContractFileUrl, mockHomeHealthCheckDetail.downloadContractFileUrl)
        
        XCTAssertEqual(homeHealthCheckDetail.landingPage.title, mockHomeHealthCheckDetail.landingPage.title)
        XCTAssertEqual(homeHealthCheckDetail.landingPage.description, mockHomeHealthCheckDetail.landingPage.description)
        XCTAssertEqual(homeHealthCheckDetail.landingPage.imageURL, mockHomeHealthCheckDetail.landingPage.imageURL)
        
        XCTAssertEqual(homeHealthCheckDetail.healthCheckRefusePage.title, mockHomeHealthCheckDetail.healthCheckRefusePage.title)
        XCTAssertEqual(homeHealthCheckDetail.healthCheckReviewPage.title, mockHomeHealthCheckDetail.healthCheckReviewPage.title)
        
        XCTAssertEqual(homeHealthCheckDetail.landingPage.questionsPage.healthQuestions.count, mockHomeHealthCheckDetail.landingPage.questionsPage.healthQuestions.count)
        XCTAssertEqual(homeHealthCheckDetail.landingPage.questionsPage.travelParty.partyMembers.count, mockHomeHealthCheckDetail.landingPage.questionsPage.travelParty.partyMembers.count)
        
    }
    
    func testExecute_Error() async {
        
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
    func testExecute_NoData() async {
        
        mockRepository.mockHealthCheckDetail = nil
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
}

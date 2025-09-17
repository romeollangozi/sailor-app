//
//  GetVoyageActivitiesContentUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 3/11/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetVoyageActivitiesContentUseCaseTests: XCTestCase {
    
    var mockRepository: VoyageActivitiesRepositoryMock!
    var useCase: GetVoyageActivitiesContentUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = VoyageActivitiesRepositoryMock()
        useCase = GetVoyageActivitiesContentUseCase(voyageActivitiesRepository: mockRepository, currentSailorManager: MockCurrentSailorManager())
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        
        let mockVoyageActivities = VoyageActivitiesSection.sample()
        mockRepository.mockVoyageActivities = mockVoyageActivities
        
        let voyageActivity = try await useCase.execute(sailingMode: "preCruise")
        
        for (index, voyageBookActivity) in voyageActivity.bookActivities.enumerated() {
            let mockVoyageBookActivity = mockVoyageActivities.bookActivities[index]
            XCTAssertEqual(voyageBookActivity.imageUrl, mockVoyageBookActivity.imageUrl)
            XCTAssertEqual(voyageBookActivity.name, mockVoyageBookActivity.name)
            XCTAssertEqual(voyageBookActivity.bookableType, mockVoyageBookActivity.bookableType)
            XCTAssertEqual(voyageBookActivity.layoutType, mockVoyageBookActivity.layoutType)
        }
        
        
        for (index, voyageExploreActivity) in voyageActivity.exploreActivities.enumerated() {
            let mockVoyageExploreActivity = mockVoyageActivities.exploreActivities[index]
            XCTAssertEqual(voyageExploreActivity.imageUrl, mockVoyageExploreActivity.imageUrl)
            XCTAssertEqual(voyageExploreActivity.name, mockVoyageExploreActivity.name)
            XCTAssertEqual(voyageExploreActivity.code, mockVoyageExploreActivity.code)
            XCTAssertEqual(voyageExploreActivity.layoutType, mockVoyageExploreActivity.layoutType)
        }
        
    }
    
    func testExecute_Error() async {
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(sailingMode: "preCruise")
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
    
    func testExecute_NoData() async {
        mockRepository.mockVoyageActivities = nil
        
        do {
            _ = try await useCase.execute(sailingMode: "preCruise")
            XCTFail("Expected an error but got a result")
        } catch{
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
}

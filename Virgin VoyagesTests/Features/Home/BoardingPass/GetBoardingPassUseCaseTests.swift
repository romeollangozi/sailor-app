//
//  GetBoardingPassUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/2/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetBoardingPassUseCaseTests: XCTestCase {
    
    var mockRepository: BoardingPassRepositoryMock!
    var useCase: GetBoardingPassUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = BoardingPassRepositoryMock()
        useCase = GetBoardingPassUseCase(
			boardingPassRepository: mockRepository,
			currentSailorManager: MockCurrentSailorManager()
		)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        
        let mockSailorBoardingPass = SailorBoardingPass.sample()
        mockRepository.mockSailorBoardingPass = mockSailorBoardingPass
        
        let sailorBoardingPass = try await useCase.execute()
        
        for (index, sailorBoardingPassItem) in sailorBoardingPass.items.enumerated() {
            
            let mockSailorBoardingPassItem = mockSailorBoardingPass.items[index]
            
            XCTAssertEqual(sailorBoardingPassItem.shipName, mockSailorBoardingPassItem.shipName)
            XCTAssertEqual(sailorBoardingPassItem.voyageName, mockSailorBoardingPassItem.voyageName)
            XCTAssertEqual(sailorBoardingPassItem.depart, mockSailorBoardingPassItem.depart)
            XCTAssertEqual(sailorBoardingPassItem.arrive, mockSailorBoardingPassItem.arrive)
            XCTAssertEqual(sailorBoardingPassItem.sailor, mockSailorBoardingPassItem.sailor)
            XCTAssertEqual(sailorBoardingPassItem.bookingRef, mockSailorBoardingPassItem.bookingRef)
            XCTAssertEqual(sailorBoardingPassItem.arrivalTime, mockSailorBoardingPassItem.arrivalTime)
            XCTAssertEqual(sailorBoardingPassItem.cabinNumber, mockSailorBoardingPassItem.cabinNumber)
            XCTAssertEqual(sailorBoardingPassItem.embarkation, mockSailorBoardingPassItem.embarkation)
            XCTAssertEqual(sailorBoardingPassItem.portLocation, mockSailorBoardingPassItem.portLocation)
            XCTAssertEqual(sailorBoardingPassItem.sailTime, mockSailorBoardingPassItem.sailTime)
            XCTAssertEqual(sailorBoardingPassItem.cabin, mockSailorBoardingPassItem.cabin)
            XCTAssertEqual(sailorBoardingPassItem.musterStation, mockSailorBoardingPassItem.musterStation)
            XCTAssertEqual(sailorBoardingPassItem.notes, mockSailorBoardingPassItem.notes)
            XCTAssertEqual(sailorBoardingPassItem.imageUrl, mockSailorBoardingPassItem.imageUrl)
            XCTAssertEqual(sailorBoardingPassItem.sailorTitle, mockSailorBoardingPassItem.sailorTitle)
            XCTAssertEqual(sailorBoardingPassItem.reservationGuestId, mockSailorBoardingPassItem.reservationGuestId)
            XCTAssertEqual(sailorBoardingPassItem.firstName, mockSailorBoardingPassItem.firstName)
            XCTAssertEqual(sailorBoardingPassItem.lastName, mockSailorBoardingPassItem.lastName)
            XCTAssertEqual(sailorBoardingPassItem.coordinates, mockSailorBoardingPassItem.coordinates)
            
        }
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
        mockRepository.mockSailorBoardingPass = nil
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch{
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
}

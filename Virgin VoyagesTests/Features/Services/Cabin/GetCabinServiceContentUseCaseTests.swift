//
//  GetCabinServiceContentUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/23/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetCabinServiceContentUseCaseTests: XCTestCase {
	
	var mockRepository: CabinServiceRepositoryMock!
	var mockCurrentSailorManager: MockCurrentSailorManager!
	var useCase: GetCabinServiceContentUseCase!
	
	override func setUp() {
		super.setUp()
		
		mockRepository = CabinServiceRepositoryMock()
		mockCurrentSailorManager = MockCurrentSailorManager()
		useCase = GetCabinServiceContentUseCase(cabinServiceRepository: mockRepository, currentSailorManager: mockCurrentSailorManager)
		
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(cabinNumber: "123456")
	}
	
	override func tearDown() {
		mockRepository = nil
		useCase = nil
		mockCurrentSailorManager = nil
		super.tearDown()
	}
	
	func testExecute_Success() async throws {
		
		let mockCabinService = CabinService.sample()
		mockRepository.mockCabinService = mockCabinService
		
		let cabinService = try await useCase.execute()
		
		XCTAssertEqual(mockCabinService.title, cabinService.title)
		XCTAssertEqual(mockCabinService.subTitle, cabinService.subTitle)
		XCTAssertEqual(mockCabinService.backgroundImageURL, cabinService.backgroundImageURL)
		
		for (index, cabinServiceItem) in cabinService.items.enumerated() {
			
			let mockCabinServiceItem = mockCabinService.items[index]
			
			XCTAssertEqual(cabinServiceItem.id, mockCabinServiceItem.id)
			XCTAssertEqual(cabinServiceItem.name, mockCabinServiceItem.name)
			XCTAssertEqual(cabinServiceItem.status, mockCabinServiceItem.status)
			XCTAssertEqual(cabinServiceItem.imageUrl, mockCabinServiceItem.imageUrl)
			XCTAssertEqual(cabinServiceItem.designStyle, mockCabinServiceItem.designStyle)
			XCTAssertEqual(cabinServiceItem.optionsTitle, mockCabinServiceItem.optionsTitle)
			XCTAssertEqual(cabinServiceItem.optionsDescription, mockCabinServiceItem.optionsDescription)
			XCTAssertEqual(cabinServiceItem.confirmationCta, mockCabinServiceItem.confirmationCta)
			XCTAssertEqual(cabinServiceItem.confirmationTitle, mockCabinServiceItem.confirmationTitle)
			XCTAssertEqual(cabinServiceItem.confirmationDescription, mockCabinServiceItem.confirmationDescription)
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
		
		mockRepository.mockCabinService = nil
		
		do {
			_ = try await useCase.execute()
			XCTFail("Expected an error but got a result")
		} catch{
			XCTAssertEqual(error as? VVDomainError, .genericError)
		}
		
	}
}

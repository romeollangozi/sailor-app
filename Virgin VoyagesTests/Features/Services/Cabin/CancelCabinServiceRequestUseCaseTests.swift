//
//  CancelCabinServiceRequestUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

import XCTest
@testable import Virgin_Voyages

final class CancelCabinServiceRequestUseCaseTests: XCTestCase {
	private var useCase: CancelCabinServiceRequestUseCase!
	private var mockCabinServiceRepository: CabinServiceRepositoryMock!
	private var mockCurrentSailorManager: MockCurrentSailorManager!
	
	override func setUp() {
		super.setUp()
		mockCabinServiceRepository = CabinServiceRepositoryMock()
		mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample().copy(cabinNumber: "1234"))
		useCase = CancelCabinServiceRequestUseCase(
			cabinServiceRepository: mockCabinServiceRepository,
			currentSailorManager: mockCurrentSailorManager
		)
	}
	
	override func tearDown() {
		useCase = nil
		mockCabinServiceRepository = nil
		mockCurrentSailorManager = nil
		super.tearDown()
	}
	
	func testExecuteSuccess() async throws {
		let requestId = UUID().uuidString
		let requestName = "freshTowels"
		
        let result = try await useCase.execute(requestId: requestId, requestName: requestName, isMaintenance: false)
		
		let expectedInput = CancelCabinServiceRequestInput(requestId: requestId, cabinNumber: mockCurrentSailorManager.lastSailor!.cabinNumber!, activeRequest: requestName)
														   
		
		XCTAssertEqual(expectedInput, mockCabinServiceRepository.cancelCabinServiceRequestInput)
        XCTAssertNotNil(result)
	}
	
	func testExecuteThrowsErrorWhenCabinNumberIsMissing() async throws {
		let requestId = UUID().uuidString
		let requestName = "freshTowels"
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(cabinNumber: "")
		
		do {
            _ = try await useCase.execute(requestId: requestId, requestName: requestName, isMaintenance: false)
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}
	
	func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
		let requestId = UUID().uuidString
		let requestName = "freshTowels"
		mockCabinServiceRepository.shouldThrowError = true
		
		do {
            _ = try await useCase.execute(requestId: requestId, requestName: requestName, isMaintenance: false)
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}
}

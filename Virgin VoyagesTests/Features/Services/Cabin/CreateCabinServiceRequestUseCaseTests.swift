//
//  CreateCabinServiceRequestUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//
import XCTest
@testable import Virgin_Voyages

final class CreateCabinServiceRequestUseCaseTests: XCTestCase {
	private var useCase: CreateCabinServiceRequestUseCase!
	private var mockCabinServiceRepository: CabinServiceRepositoryMock!
	private var mockCurrentSailorManager: MockCurrentSailorManager!
	
	override func setUp() {
		super.setUp()
		mockCabinServiceRepository = CabinServiceRepositoryMock()
		mockCurrentSailorManager = MockCurrentSailorManager(lastSailor: CurrentSailor.sample().copy(cabinNumber: "1234"))
		useCase = CreateCabinServiceRequestUseCase(
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
		let requestName = "freshTowels"
		
        let result = try await useCase.execute(requestName: requestName, isMaintenance: false)
		
		let expectedInput = CreateCabinServiceRequestInput(reservationId: mockCurrentSailorManager.lastSailor!.reservationId,
														  reservationGuestId: mockCurrentSailorManager.lastSailor!.reservationGuestId,
													   guestId: mockCurrentSailorManager.lastSailor!.guestId,
													   cabinNumber: mockCurrentSailorManager.lastSailor!.cabinNumber!,
													   requestName: requestName)
		
		XCTAssertEqual(expectedInput, mockCabinServiceRepository.createCabinServiceRequestInput)
		XCTAssertFalse(result.requestId.isEmpty)
	}
	
	func testExecuteThrowsErrorWhenCabinNumberIsMissing() async throws {
		let requestName = "freshTowels"
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(cabinNumber: "")
		
		do {
            _ = try await useCase.execute(requestName: requestName, isMaintenance: false)
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}
	
	func testExecuteThrowsErrorWhenRepositoryThrowsError() async throws {
		let requestName = "freshTowels"
		mockCabinServiceRepository.shouldThrowError = true
		
		do {
            _ = try await useCase.execute(requestName: requestName, isMaintenance: false)
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}
}

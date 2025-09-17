//
//  GetSailorDateAndTimeUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 8.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetSailorDateAndTimeUseCaseTests: XCTestCase {

    private var mockDateTimeRepository: MockDateTimeRepository!
    private var mockClock: MockClock!
    private var useCase: GetSailorDateAndTimeUseCase!

    override func setUp() {
        super.setUp()
        mockDateTimeRepository = MockDateTimeRepository()
        mockClock = MockClock()
        useCase = GetSailorDateAndTimeUseCase(
            dateTimeRepository: mockDateTimeRepository
        )
    }

    override func tearDown() {
        mockDateTimeRepository = nil
        mockClock = nil
        useCase = nil
        super.tearDown()
    }

    func testExecuteShouldReturnShipTime() async {
        let expectedDate = Date(timeIntervalSince1970: 1234567890)
        mockDateTimeRepository.mockShipTime = expectedDate
        
        let useCase = GetSailorDateAndTimeUseCase(dateTimeRepository: mockDateTimeRepository)

        let result = await useCase.execute()

        XCTAssertEqual(result, expectedDate)
    }
}

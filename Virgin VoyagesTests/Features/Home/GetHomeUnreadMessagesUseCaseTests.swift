//
//  GetHomeUnreadMessagesUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/1/25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeUnreadMessagesUseCaseTests: XCTestCase {

    var mockRepository: HomeUnreadMessagesRepositoryMock!
    var useCase: GetHomeUnreadMessagesUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = HomeUnreadMessagesRepositoryMock()
        useCase = GetHomeUnreadMessagesUseCase(
			homeUnreadMessagesRepository: mockRepository,
			currentSailorManager: MockCurrentSailorManager()
		)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        
        let mockHomeUnreadMessages = HomeUnreadMessages.sample()
        mockRepository.mockHomeUnreadMessages = mockHomeUnreadMessages
        
        let homeUnreadMessages = try await useCase.execute()
        
        XCTAssertEqual(homeUnreadMessages.total, mockHomeUnreadMessages.total)
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
        mockRepository.mockHomeUnreadMessages = nil
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got a result")
        } catch{
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
        
    }
    
}


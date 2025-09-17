//
//  GetChatThreadsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetChatThreadsUseCaseTests: XCTestCase {
    
    var useCase: GetChatThreadsUseCase!
    var mockRepository: MockChatThreadsRepository!
    var mockSailorManager: MockCurrentSailorManager!
    var mockSailorDataRepository: MockSailorChatDataRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockChatThreadsRepository()
        mockSailorManager = MockCurrentSailorManager()
        mockSailorDataRepository = MockSailorChatDataRepository()
        
        useCase = GetChatThreadsUseCase(repository: mockRepository,
                                        currentSailorManager: mockSailorManager,
                                        sailorDataRepository: mockSailorDataRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        mockSailorManager = nil
        mockSailorDataRepository = nil
        super.tearDown()
    }
    
    func testExecuteReturnsSortedThreads() async throws {
        let unsortedThreads: [ChatThread] = [
            .init(id: "2", title: "", unreadCount: 0, isClosed: false, type: .sailorServices, description: "", lastMessageTime: "", imageURL: ""),
            .init(id: "3", title: "", unreadCount: 0, isClosed: false, type: .sailorServices, description: "", lastMessageTime: "", imageURL: ""),
            .init(id: "1", title: "", unreadCount: 0, isClosed: false, type: .sailorServices, description: "", lastMessageTime: "", imageURL: ""),
            
        ]
        mockRepository.mockThreads = unsortedThreads
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.map { $0.id }, ["3", "2", "1"], "Threads should be sorted in descending order by ID")
    }

    func testExecuteThrowsErrorWhenRepositoryFails() async {

        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = VVDomainError.genericError
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but got success")
        } catch {
            XCTAssertEqual(error as? VVDomainError, VVDomainError.genericError, "Should throw notFound error")
        }
    }

    func testExecuteHandlesEmptyThreads() async throws {
        mockRepository.mockThreads = []
        
        let result = try await useCase.execute()
        
        XCTAssertTrue(result.isEmpty, "Result should be an empty list")
    }

}

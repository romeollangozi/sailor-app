//
//  MarkChatMessagesAsReadUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 19.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class MarkChatMessagesAsReadUseCaseTests: XCTestCase {
    // MARK: - Properties
    var useCase: MarkChatMessagesAsReadUseCase!
    var mockRepository: MockChatThreadMessagesRepository!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockRepository = MockChatThreadMessagesRepository()
        useCase = MarkChatMessagesAsReadUseCase(
            repository: mockRepository
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testExecute_SuccessfulMarking_ReturnsTrue() async throws {
        // Given
        mockRepository.shouldThrow = false
        let messageIDs = [101, 102, 103]
        
        // When
        let result = try await useCase.execute(messagesIDs: messageIDs, threadID: "", chatType: .crew)
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testExecute_RepositoryThrows_ThrowsError() async {
        // Given
        mockRepository.shouldThrow = true
        
        // When / Then
        do {
            _ = try await useCase.execute(messagesIDs: [10, 20], threadID: "", chatType: .crew)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}

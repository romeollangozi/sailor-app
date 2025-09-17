//
//  SendMessageUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.2.25.
//

import XCTest
@testable import Virgin_Voyages

final class SendMessageUseCaseTests: XCTestCase {

	// MARK: - Mock Dependencies
	var mockRepository: MockSendMessageRepository!
	var mockCurrentSailorManager: MockCurrentSailorManager!
	var mockSailorChatDataRepository: MockSailorChatDataRepository!

	// MARK: - System Under Test
	var useCase: SendMessageUseCase!

	// MARK: - Setup & Teardown
	override func setUp() {
		super.setUp()
		mockRepository = MockSendMessageRepository()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockSailorChatDataRepository = MockSailorChatDataRepository()

		useCase = SendMessageUseCase(
			sendMessageRepository: mockRepository,
			currentSailorManager: mockCurrentSailorManager,
			sailorChatDataRepository: mockSailorChatDataRepository
		)
	}

	override func tearDown() {
		useCase = nil
		mockRepository = nil
		mockCurrentSailorManager = nil
		mockSailorChatDataRepository = nil
		super.tearDown()
	}

	// MARK: - Tests
	func testSendMessageSuccess() async throws {
		let expectedMessage = SendMessage(id: 123, result: "success", msg: "Hello", varName: "", code: "")

		mockRepository.mockSendMessage = expectedMessage
		mockSailorChatDataRepository.mockSailorChatData = SailorChatData.mock()

        let result = try await useCase.execute(message: "Hello", chatType: .crew, to: "")

		XCTAssertEqual(result.id, expectedMessage.id)
		XCTAssertEqual(result.result, expectedMessage.result)
		XCTAssertEqual(result.msg, expectedMessage.msg)
	}

	func testNoSailorChatData() async throws {
		mockSailorChatDataRepository.mockSailorChatData = nil

		let result = try await useCase.execute(message: "Hello", chatType: .crew, to: "")

		XCTAssertEqual(result, SendMessage.empty())
	}

	func testRepositoryReturnsNil() async throws {
		mockRepository.mockSendMessage = nil
		mockSailorChatDataRepository.mockSailorChatData = SailorChatData.mock()

        let result = try await useCase.execute(message: "Hello", chatType: .crew, to: "")

		XCTAssertEqual(result, SendMessage.empty())
	}
}

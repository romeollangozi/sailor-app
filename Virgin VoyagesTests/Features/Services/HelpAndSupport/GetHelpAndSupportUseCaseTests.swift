//
//  GetHelpAndSupportUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

import XCTest

@testable import Virgin_Voyages


final class GetHelpAndSupportUseCaseTests: XCTestCase {
	private var repositoryMock: HelpAndSupportRepositoryProtocolMock!
	private var useCase: GetHelpAndSupportUseCase!

	override func setUp() {
		super.setUp()
		repositoryMock = HelpAndSupportRepositoryProtocolMock()
		useCase = GetHelpAndSupportUseCase(repository: repositoryMock)
	}

	override func tearDown() {
		repositoryMock = nil
		useCase = nil
		super.tearDown()
	}

	func testExecuteShoulReturnHelpAndSupport() async throws {
		let expectedHelpAndSupport = HelpAndSupport.sample()
		repositoryMock.result = expectedHelpAndSupport

		let result = try await useCase.execute()

		XCTAssertEqual(result, expectedHelpAndSupport)
	}

	func testExecuteShoulThrowWhenDataIsNotAvailable() async throws {
		repositoryMock.result = nil

		do {
			_ = try await useCase.execute()
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}

}

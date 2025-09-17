//
//  ResponseHandlerTests.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/30/25.
//


import XCTest
@testable import Virgin_Voyages

final class ResponseHandlerTests: XCTestCase {

    private var sut: ResponseHandler!

    override func setUp() {
        super.setUp()
        sut = ResponseHandler()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test Models

    struct MockModel: Decodable, Equatable {
        let name: String
    }

    // MARK: - Success Case

    func testHandle_withValidData_returnsDecodedModel() throws {
        let jsonData = """
        { "name": "Test Ship" }
        """.data(using: .utf8)!

        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let result = try sut.handle(data: jsonData, response: response, responseModel: MockModel.self)
        XCTAssertEqual(result, MockModel(name: "Test Ship"))
    }

    // MARK: - Error Cases

    func testHandle_with400_returnsBadRequestError() {
        let response = makeHTTPResponse(statusCode: 400)
        let data = Data()

        XCTAssertThrowsError(try sut.handle(data: data, response: response, responseModel: MockModel.self)) { error in
            XCTAssertEqual(error as? NetworkServiceError, .badRequest)
        }
    }

    func testHandle_with401_returnsUnauthorizedError() {
        let response = makeHTTPResponse(statusCode: 401)
        let data = Data()

        XCTAssertThrowsError(try sut.handle(data: data, response: response, responseModel: MockModel.self)) { error in
            XCTAssertEqual(error as? NetworkServiceError, .unauthorized)
        }
    }

    func testHandle_with500_returnsGenericError() {
        let response = makeHTTPResponse(statusCode: 500)
        let data = Data()

        XCTAssertThrowsError(try sut.handle(data: data, response: response, responseModel: MockModel.self)) { error in
            XCTAssertEqual(error as? NetworkServiceError, .genericError)
        }
    }

    // MARK: - parseApiError

	func testParseApiError_withUnknownFormat_returnsUnknownError() {
		let apiErrorJSON = """
		{ "message": "Invalid input" }
		""".data(using: .utf8)!

		let result = sut.parseApiError(from: apiErrorJSON)

		if case let .APIError(apiError) = result,
		   case let .unknownError(message) = apiError {
			XCTAssertEqual(message, "Unknown error format")
		} else {
			XCTFail("Expected APIError.unknownError")
		}
	}

    func testParseApiError_withInvalidData_returnsNil() {
        let invalidData = "Not JSON".data(using: .utf8)!
        let result = sut.parseApiError(from: invalidData)
        XCTAssertNil(result)
    }

    // MARK: - Helpers

    private func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

//
//  DeepLinkJSONEncoderTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 8/17/25.
//

import XCTest
@testable import Virgin_Voyages // Replace with your actual module name

final class DeepLinkJSONEncoderTests: XCTestCase {
    
    private var sut: DeepLinkJSONEncoderProtocol!
    
    override func setUp() {
        super.setUp()
        sut = DeepLinkJSONEncoder()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testEncodeExternalURLLink_WithValidURL_ReturnsCorrectTypeAndJSON() {
        // Given
        let url = "https://www.virginvoyages.com/addContact?type=add.contact&reservationGuestId=1f6db0d2-9590-406c-af4b-f146a0d64e80&reservationId=8f0ed440-fead-47ff-a041-ba69e2fc368e&voyageNumber=SC2508204NKW&name=Elma"
        let expectedType = "add.contact"
        let expectedJSON = "{\"reservationGuestId\":\"1f6db0d2-9590-406c-af4b-f146a0d64e80\",\"reservationId\":\"8f0ed440-fead-47ff-a041-ba69e2fc368e\",\"voyageNumber\":\"SC2508204NKW\",\"name\":\"Elma\"}"
        
        // When
        let result = sut.encodeExternalURLLink(url: url)
        
        // Then
        XCTAssertEqual(result.type, expectedType)
        XCTAssertEqual(result.jsonString, expectedJSON)
    }
    
    func testEncodeExternalURLLink_WithSingleParameter_ReturnsTypeAndEmptyJSON() {
        // Given
        let url = "https://example.com/path?type=reservation.canceled"
        let expectedType = "reservation.canceled"
        let expectedJSON = "{}"
        
        // When
        let result = sut.encodeExternalURLLink(url: url)
        
        // Then
        XCTAssertEqual(result.type, expectedType)
        XCTAssertEqual(result.jsonString, expectedJSON)
    }
    
    func testEncodeExternalURLLink_WithMultipleParameters_PreservesOrder() {
        // Given
        let url = "https://example.com/test?first=A&second=B&third=C&fourth=D"
        let expectedType = "A"
        let expectedJSON = "{\"second\":\"B\",\"third\":\"C\",\"fourth\":\"D\"}"
        
        // When
        let result = sut.encodeExternalURLLink(url: url)
        
        // Then
        XCTAssertEqual(result.type, expectedType)
        XCTAssertEqual(result.jsonString, expectedJSON)
    }
    
    func testEncodeExternalURLLink_WithInvalidURL_ReturnsEmptyValues() {
        // Given
        let invalidURL = "not-a-valid-url"
        let expectedType = ""
        let expectedJSON = "{}"
        
        // When
        let result = sut.encodeExternalURLLink(url: invalidURL)
        
        // Then
        XCTAssertEqual(result.type, expectedType)
        XCTAssertEqual(result.jsonString, expectedJSON)
    }
    
    func testEncodeExternalURLLink_WithSpecialCharacters_EscapesCorrectly() {
        // Given
        let url = "https://example.com/test?first=hello%20world&second=test%22quotes%22&third=value%26ampersand"
        let expectedType = "hello world"
        let expectedJSON = "{\"second\":\"test\\\"quotes\\\"\",\"third\":\"value&ampersand\"}"
        
        // When
        let result = sut.encodeExternalURLLink(url: url)
        
        // Then
        XCTAssertEqual(result.type, expectedType)
        XCTAssertEqual(result.jsonString, expectedJSON)
    }
}

//
//  SaveTravelDocumentBodyTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class SaveTravelDocumentBodyTests: XCTestCase {

    func testEncodingProducesCorrectJSON() throws {
        // Given
        let fields: [String: String] = [
            "value1": "test",
            "value2": "test2"
        ]
        
        let rules: [DocumentCombinedRule] = [
            DocumentCombinedRule(
                sourceDocumentType: "DL",
                destinationDocumentType: "BC",
                field: "number",
                saveType: "Auto Save"
            )
        ]
        
        let body = SaveTravelDocumentBody(fields: fields, documentCombinedRules: rules)

        // When
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try encoder.encode(body)
        
        // Then
        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]

        XCTAssertEqual(decoded?["value1"] as? String, "test")
        XCTAssertEqual(decoded?["value2"] as? String, "test2")

        guard let rulesArray = decoded?["documentCombinedRules"] as? [[String: Any]] else {
            XCTFail("documentCombinedRules is not properly encoded")
            return
        }

        XCTAssertEqual(rulesArray.count, 1)
        XCTAssertEqual(rulesArray[0]["sourceDocumentType"] as? String, "DL")
        XCTAssertEqual(rulesArray[0]["destinationDocumentType"] as? String, "BC")
        XCTAssertEqual(rulesArray[0]["field"] as? String, "number")
        XCTAssertEqual(rulesArray[0]["saveType"] as? String, "Auto Save")
    }
   
}

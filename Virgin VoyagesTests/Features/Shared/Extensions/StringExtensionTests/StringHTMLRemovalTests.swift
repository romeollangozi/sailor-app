//
//  StringHTMLRemovalTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class StringHTMLRemovalTests: XCTestCase {
    
    func test_removingHTMLTags_removesBasicTags() {
        let input = "<p>Hello world</p>"
        let expected = "Hello world"
        XCTAssertEqual(input.removingHTMLTags(), expected)
    }
    
    func test_removingHTMLTags_removesMultipleTags() {
        let input = "<div><strong>Bold</strong> and <em>italic</em></div>"
        let expected = "Bold and italic"
        XCTAssertEqual(input.removingHTMLTags(), expected)
    }

    func test_removingHTMLTags_handlesNbspEntity() {
        let input = "&nbsp;Hello&nbsp;world&nbsp;"
        let expected = " Hello world "
        XCTAssertEqual(input.removingHTMLTags(), expected)
    }

    func test_removingHTMLTags_withMixedTagsAndEntities() {
        let input = "<p>&nbsp;Text&nbsp;with&nbsp;<b>bold</b>&nbsp;words.</p>"
        let expected = " Text with bold words."
        XCTAssertEqual(input.removingHTMLTags(), expected)
    }

    func test_removingHTMLTags_withEmptyString() {
        let input = ""
        let expected = ""
        XCTAssertEqual(input.removingHTMLTags(), expected)
    }

    func test_removingHTMLTags_withoutAnyTags() {
        let input = "Just plain text"
        let expected = "Just plain text"
        XCTAssertEqual(input.removingHTMLTags(), expected)
    }
}

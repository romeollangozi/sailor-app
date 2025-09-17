//
//  HelpAndSupportTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.4.25.
//

import XCTest

@testable import Virgin_Voyages

final class HelpAndSupportTests: XCTestCase {
	func testWithArticles_filterByCategoryId() {
		let categories = [HelpAndSupport.Category.sample().copy(sequenceNumber: "1", articles: [HelpAndSupport.Article.sample()]),
						  HelpAndSupport.Category.sample().copy(sequenceNumber: "2", articles: [HelpAndSupport.Article.sample()])]
		
		let filtered = categories.withArticles(categoryId: "1")
		
		XCTAssertEqual(filtered.count, 1)
		XCTAssertEqual(filtered.first?.sequenceNumber, "1")
	}
	
	func testWithArticles_filterBySearchString() {
		let categories = [HelpAndSupport.Category.sample().copy(sequenceNumber: "1", articles: [HelpAndSupport.Article.sample().copy(name: "hello")]),
						  HelpAndSupport.Category.sample().copy(sequenceNumber: "2", articles: [HelpAndSupport.Article.sample().copy(name:"What")])]
		
		let filtered = categories.withArticles(searchString: "hello")
		
		XCTAssertEqual(filtered.count, 1)
		XCTAssertEqual(filtered.first?.articles.count, 1)
	}
	
	func testWithArticles_filterByCategoryIdAndSearchString() {
		let categories = [HelpAndSupport.Category.sample().copy(sequenceNumber: "1", articles: [HelpAndSupport.Article.sample().copy(name: "hello")]),
						  HelpAndSupport.Category.sample().copy(sequenceNumber: "2", articles: [HelpAndSupport.Article.sample().copy(name:"What")])]
		
		let filtered = categories.withArticles(searchString: "hello", categoryId: "1")
		
		XCTAssertEqual(filtered.count, 1)
		XCTAssertEqual(filtered.first?.sequenceNumber, "1")
		XCTAssertEqual(filtered.first?.articles.count, 1)
	}
	
	func testWithArticles_noFilters() {
		let categories = [HelpAndSupport.Category.sample().copy(sequenceNumber: "1", articles: [HelpAndSupport.Article.sample()]),
						  HelpAndSupport.Category.sample().copy(sequenceNumber: "2", articles: [])]
		
		let filtered = categories.withArticles()
		
		XCTAssertEqual(filtered.count, 1)
		XCTAssertEqual(filtered.first?.sequenceNumber, "1")
	}
	
	func testWithArticles_emptyCategories() {
		var categories: [HelpAndSupport.Category] = []
		
		let filtered = categories.withArticles()
		
		XCTAssertTrue(filtered.isEmpty)
	}
}

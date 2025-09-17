//
//  WarningPassportExpireViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 30.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class WarningPassportExpireViewModelTests: XCTestCase {

    var sut: WarningPassportExpireViewModel!
    var sampleDocument: TravelDocumentDetails!

    override func setUp() {
        super.setUp()
        sampleDocument = TravelDocumentDetails.sample()
        sut = WarningPassportExpireViewModel(document: sampleDocument)
    }

    override func tearDown() {
        sut = nil
        sampleDocument = nil
        super.tearDown()
    }

    func test_onAppear_setsScreenStateToContent() {
        sut.screenState = .loading
        sut.onAppear()
        XCTAssertEqual(sut.screenState, .content)
    }

    func test_init_setsTitleAndDescriptionFromDocument() {
        XCTAssertEqual(sut.title, "Warning: Expired Passport")
        XCTAssertEqual(sut.htmlDescription, "<p>Your passport may be expired</p>")
    }

    func test_navigateBack_doesNotCrash() {
        sut.navigateBack()
        XCTAssertTrue(true)
    }
}

//
//  InfoDrawerViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 15.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class InfoDrawerViewModelTests: XCTestCase {

    func test_title_returnsDocumentName_whenESTADocumentProvided() {
        // Given
        let document = TravelDocuments.Document.sample(
            name: "ESTA",
            code: DocumentType.electronicSystemForTravelAuthorization.rawValue
        )
        let travelDocs = TravelDocuments.sample()
        let viewModel = InfoDrawerViewModel(travelDocuments: travelDocs, document: document)

        // Then
        XCTAssertEqual(viewModel.title, "ESTA")
    }

    func test_title_returnsEnteringMessage_whenDocumentIsNil() {
        let travelDocs = TravelDocuments.sample(debarkCountryName: "Italy")
        let viewModel = InfoDrawerViewModel(travelDocuments: travelDocs, document: nil)

        XCTAssertEqual(viewModel.title, "Entering Italy")
    }

    func test_description_returnsESTADescription_whenESTADocumentProvided() {
        let document = TravelDocuments.Document.sample(
            name: "ESTA",
            code: DocumentType.electronicSystemForTravelAuthorization.rawValue
        )
        let travelDocs = TravelDocuments.sample(debarkCountryName: "France")
        let viewModel = InfoDrawerViewModel(travelDocuments: travelDocs, document: document)

        XCTAssertTrue(viewModel.description.contains("Visa Waiver Program"))
        XCTAssertTrue(viewModel.description.contains("France"))
    }

    func test_description_returnsGenericDescription_whenNotESTA() {
        let document = TravelDocuments.Document.sample(
            name: "Passport",
            code: "PASSPORT"
        )
        let travelDocs = TravelDocuments.sample(debarkCountryName: "Spain")
        let viewModel = InfoDrawerViewModel(travelDocuments: travelDocs, document: document)

        XCTAssertTrue(viewModel.description.contains("you must show valid travel documents"))
        XCTAssertTrue(viewModel.description.contains("Spain"))
    }

    func test_url_returnsValidGovernmentLink_whenURLIsValid() {
        let travelDocs = TravelDocuments.sample(governmentLink: "https://example.com")
        let viewModel = InfoDrawerViewModel(travelDocuments: travelDocs, document: nil)

        XCTAssertEqual(viewModel.url.absoluteString, "https://example.com")
    }

    func test_buttonTitle_isCorrect() {
        let viewModel = InfoDrawerViewModel(travelDocuments: .empty(), document: nil)

        XCTAssertEqual(viewModel.buttonTitle, "Open in Browser")
    }
}

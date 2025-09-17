//
//  DocumentTypeSelectionViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 20.8.25.
//

import XCTest
@testable import Virgin_Voyages

final class DocumentTypeSelectionViewModelTests: XCTestCase {

    private var viewModel: DocumentTypeSelectionViewModel!
    private var testRouter: TestNavigationRouter<TravelDocumentsRoute>!
    private var coordinator: TravelDocumentsCoordinator!
    private var travelDocuments: TravelDocuments!
    private var documentStage: TravelDocuments.DocumentStage!

    override func setUp() {
        super.setUp()

        let scanable = TravelDocuments.Document(
            name: "Passport",
            type: "passport",
            code: "P",
            categoryCode: "A",
            categoryId: "1",
            isScanable: true,
            isCapturable: false,
            isTwiceSide: false,
            isAlreadyUploaded: false,
            scanFormatType: .passportOrVisa,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: false,
            categoryDetails: nil
        )

        let capturable = TravelDocuments.Document(
            name: "ID Card",
            type: "id",
            code: "ID",
            categoryCode: "B",
            categoryId: "2",
            isScanable: false,
            isCapturable: true,
            isTwiceSide: true,
            isAlreadyUploaded: false,
            scanFormatType: .cardFormatTwoSides,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: false,
            categoryDetails: nil
        )

        let declaration = TravelDocuments.Document(
            name: "Visa",
            type: "visa",
            code: "V",
            categoryCode: "C",
            categoryId: "3",
            isScanable: false,
            isCapturable: false,
            isTwiceSide: false,
            isAlreadyUploaded: false,
            scanFormatType: .passportOrVisa,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: false,
            categoryDetails: nil
        )

        travelDocuments = TravelDocuments.empty()

        documentStage = TravelDocuments.DocumentStage(
            title: "Select a Document Type",
            description: "Choose one of the supported document types",
            isChoisable: true,
            isCompleted: false,
            documents: [scanable, capturable, declaration]
        )

        testRouter = TestNavigationRouter<TravelDocumentsRoute>()
        coordinator = TravelDocumentsCoordinator(navigationRouter: testRouter)

        viewModel = DocumentTypeSelectionViewModel(
            coordinator: coordinator
        )
    }

    func test_onDocumentSelect_setsSelectedDocument_andShowsMultiCategorySheet_whenMultiCategoryDocument() {
        // Given a multi-category document
        let multiCategoryDoc = TravelDocuments.Document(
            name: "ID",
            type: "card",
            code: "C",
            categoryCode: "CAT1",
            categoryId: "1",
            isScanable: false,
            isCapturable: true,
            isTwiceSide: false,
            isAlreadyUploaded: false,
            scanFormatType: .cardFormatMrz,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: true,
            categoryDetails: TravelDocuments.CategoryDetails(
                title: "Choose a document",
                description: "Pick one from below",
                categories: []
            )
        )

        // Ensure precondition
        XCTAssertFalse(viewModel.isShowingMultiCategorySelection)

        // When
        viewModel.onDocumentSelect(document: multiCategoryDoc)

        // Then
        XCTAssertEqual(viewModel.selectedDocument.name, multiCategoryDoc.name)
        XCTAssertTrue(viewModel.isShowingMultiCategorySelection)
    }
    
    func test_onDocumentSelect_navigates_to_scan_if_scanable() {
        let scanableDoc = documentStage.documents[0]
        viewModel.onDocumentSelect(document: scanableDoc)

        guard case let .documentScanPreparation(document, landing) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .documentScanPreparation")
        }

        XCTAssertEqual(document.name, "Passport")
        XCTAssertEqual(landing, travelDocuments)
    }

    func test_onDocumentSelect_navigates_to_capture_if_capturable() {
        let capturableDoc = documentStage.documents[1]
        viewModel.onDocumentSelect(document: capturableDoc)

        guard case let .documentScanPreparation(document, landing) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .documentCapturePreparation")
        }

        XCTAssertEqual(document.name, "ID Card")
        XCTAssertEqual(landing, travelDocuments)
    }

    func test_onDocumentSelect_navigates_to_declaration_if_neither_scanable_nor_capturable() {
        let declarationDoc = documentStage.documents[2]
        viewModel.onDocumentSelect(document: declarationDoc)

        guard case let .documentDeclarationPreparation(document, landing) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .documentDeclarationPreparation")
        }

        XCTAssertEqual(document.name, "Visa")
        XCTAssertEqual(landing, travelDocuments)
    }
    
    func test_onMultiCategoryDocumentSelect_navigates_to_scan_if_scanable_or_capturable() {
        let multiScanable = TravelDocuments.Document(
            name: "Multi Passport",
            type: "passport",
            code: "MP",
            categoryCode: "MC",
            categoryId: "10",
            isScanable: true,
            isCapturable: false,
            isTwiceSide: false,
            isAlreadyUploaded: false,
            scanFormatType: .passportOrVisa,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: true,
            categoryDetails: nil
        )

        viewModel.onMultiCategoryDocumentSelect(document: multiScanable)

        guard case let .documentScanPreparation(document, landing) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .documentScanPreparation route")
        }

        XCTAssertEqual(document.name, "Multi Passport")
        XCTAssertEqual(landing, travelDocuments)
    }

    func test_onMultiCategoryDocumentSelect_navigates_to_declaration_if_not_scanable_nor_capturable() {
        let multiDeclaration = TravelDocuments.Document(
            name: "Multi Visa",
            type: "visa",
            code: "MV",
            categoryCode: "MC",
            categoryId: "11",
            isScanable: false,
            isCapturable: false,
            isTwiceSide: false,
            isAlreadyUploaded: false,
            scanFormatType: .passportOrVisa,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: true,
            categoryDetails: nil
        )

        viewModel.onMultiCategoryDocumentSelect(document: multiDeclaration)

        guard case let .documentDeclarationPreparation(document, landing) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .documentDeclarationPreparation route")
        }

        XCTAssertEqual(document.name, "Multi Visa")
        XCTAssertEqual(landing, travelDocuments)
    }
    
    func test_onMultiCategoryDocumentSelect_navigates_to_confirmation_if_already_uploaded() {
        // Given a document that is already uploaded
        let alreadyUploadedDoc = TravelDocuments.Document(
            name: "Uploaded Passport",
            type: "passport",
            code: "UP",
            categoryCode: "MC",
            categoryId: "12",
            isScanable: true,
            isCapturable: false,
            isTwiceSide: false,
            isAlreadyUploaded: true, // Important part for this test
            scanFormatType: .passportOrVisa,
            documentId: "",
            mrzField: .none,
            isMultiCategoryDocument: true,
            categoryDetails: nil
        )

        // When
        viewModel.onMultiCategoryDocumentSelect(document: alreadyUploadedDoc)

        // Then
        guard case let .confirmationAlert(document, landing) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .confirmationAlert route")
        }

        XCTAssertEqual(document.name, "Uploaded Passport")
        XCTAssertEqual(landing, travelDocuments)
        XCTAssertFalse(viewModel.isShowingMultiCategorySelection)
    }
}

final class TestNavigationRouter<Route: Hashable>: NavigationRouter<Route> {
    private(set) var navigatedRoutes: [Route] = []
    private(set) var navigateBackCalled = false

    override func navigateTo(_ route: Route, animation: Bool = true) {
        navigatedRoutes.append(route)
        super.navigateTo(route, animation: animation)
    }

    var lastNavigatedRoute: Route? {
        navigatedRoutes.last
    }
    
    override func navigateBack(animation: Bool = true) { navigateBackCalled = true }

}

//
//  ScanDocumentViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 5/30/25.
//

import Foundation

import XCTest
@testable import Virgin_Voyages

@MainActor
final class ScanDocumentViewModelTests: XCTestCase {
    
    var sut: ScanDocumentViewModel!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockTravelDocumentDetailsRepository!
    var mockScanTravelDocumentUseCase: ScanTravelDocumentUseCase!
    
    override  func setUp() {
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockTravelDocumentDetailsRepository()
        mockScanTravelDocumentUseCase = ScanTravelDocumentUseCase(
            currentSailorManager: mockSailorManager,
            scanTravelDocumentRepository: mockRepository
        )
        
    }
    
    override func tearDown() {
        
        mockSailorManager = nil
        mockRepository = nil
        mockScanTravelDocumentUseCase = nil
        
        sut = nil
        super.tearDown()
    }
    
    func test_descriptionText_whenCardFormatIsCapturable() {
        let document = TravelDocuments.Document.sample(scanFormatType: .capturable)
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document, isSecondScan: false)
        
        XCTAssertEqual(sut.descriptionText(), "Position your document within the box")
    }
    
    func test_descriptionText_whenCardFormatTwoSides_andNotSecondScan_returnsFrontScanText() {
        let document = TravelDocuments.Document.sample(scanFormatType: .cardFormatTwoSides)
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document, isSecondScan: false)
        
        XCTAssertEqual(sut.descriptionText(), "Scan the front of your document")
    }
    
    func test_descriptionText_whenIsSecondScan_returnsBackScanText() {
        let document = TravelDocuments.Document.sample(scanFormatType: .cardFormatTwoSides)
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document, isSecondScan: true)
        sut.isSecondScan = true
        XCTAssertEqual(sut.descriptionText(), "Please scan the back of your document")
    }
    
    func test_descriptionText_whenDocumentCodeIsDL_returnsSimpleInstruction() {
        let document = TravelDocuments.Document.sample(code: "DL", scanFormatType: .passportOrVisa)
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document, isSecondScan: false)
        
        XCTAssertEqual(sut.descriptionText(), "Take a photo of the front of your licence ensuring it fits within the box.")
    }
    
    func test_descriptionText_whenNoneOfTheConditionsMatch_returnsDefaultInstruction() {
        let document = TravelDocuments.Document.sample(code: "PAS", scanFormatType: .passportOrVisa)
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document, isSecondScan: false)
        
        XCTAssertEqual(sut.descriptionText(), "Position your document within the box with the code within the dotted area.")
    }
    
    func test_frameHeight_whenDocumentIsBirthCertificate_returns500() {
        let document = TravelDocuments.Document.sample(code: DocumentType.birthCertificate.rawValue)
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document,
                                    isSecondScan: false)
        
        XCTAssertEqual(sut.frameHeight(), 500)
    }

    func test_frameHeight_whenDocumentIsNotBirthCertificate_returns250() {
        let document = TravelDocuments.Document.sample(code: "P")
        sut = ScanDocumentViewModel(scanTravelDocumentUseCase: mockScanTravelDocumentUseCase,
                                    document: document,
                                    isSecondScan: false)
        
        XCTAssertEqual(sut.frameHeight(), 250)
    }
    
    func test_handlePostUploadNavigation_whenFirstScanOfTwoSidedDocument_navigatesToTwoSideScan() async {
        // Given a two-sided document and isSecondScan = false
        let document = TravelDocuments.Document.sample(
            isTwiceSide: true,
            isAlreadyUploaded: false,
            scanFormatType: .cardFormatTwoSides
        )
        
        let testRouter = TestNavigationRouter<TravelDocumentsRoute>()
        let coordinator = TravelDocumentsCoordinator(navigationRouter: testRouter)

        let viewModel = ScanDocumentViewModel(coordinator: coordinator, document: document)


        // When
        await viewModel.handlePostUploadNavigation(photoUrl: "", imageData: Data())

        // Then
        guard case let .twoSideScan(navigatedDoc, _) = testRouter.lastNavigatedRoute else {
            return XCTFail("Expected .twoSideScan route")
        }

        XCTAssertEqual(navigatedDoc.name, document.name)
    }
    
    func test_handlePostUploadNavigation_whenFromConfirmation_callsCompletion() async {
        let document = TravelDocuments.Document.sample(scanFormatType: .passportOrVisa)
        let testRouter = TestNavigationRouter<TravelDocumentsRoute>()
        let coordinator = TravelDocumentsCoordinator(navigationRouter: testRouter)

        let viewModel = ScanDocumentViewModel(
            coordinator: coordinator,
            document: document,
            isSecondScan: false
        )

        viewModel.isFromConfirmation = true
        
        var didCallCompletion = false
        viewModel.onCompletion = { frontId, backId in
            didCallCompletion = true
            XCTAssertEqual(frontId, "")
            XCTAssertEqual(backId, "")
        }

        await viewModel.handlePostUploadNavigation(photoUrl: "", imageData: Data())

        XCTAssertNil(coordinator.fullScreenRouter)
        XCTAssertTrue(didCallCompletion)
    }
}

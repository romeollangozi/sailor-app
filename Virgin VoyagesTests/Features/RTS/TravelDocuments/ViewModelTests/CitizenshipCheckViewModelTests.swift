//
//  CitizenshipCheckViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.9.25.
//

import XCTest
@testable import Virgin_Voyages

final class CitizenshipCheckViewModelTests: XCTestCase {

    // SUT
    private var viewModel: CitizenshipCheckViewModel!

    // Mocks
    private var router: TestNavigationRouter<TravelDocumentsRoute>!
    private var coordinator: TravelDocumentsCoordinator!
    private var getDocsUseCase: MockGetTravelDocumentsUseCase!

    override func setUp() {
        super.setUp()
        router = TestNavigationRouter<TravelDocumentsRoute>()
        coordinator = TravelDocumentsCoordinator(navigationRouter: router)
        getDocsUseCase = MockGetTravelDocumentsUseCase()

        viewModel = CitizenshipCheckViewModel(
            coordinator: coordinator,
            getTravelDocumentsUseCase: getDocsUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        getDocsUseCase = nil
        coordinator = nil
        router = nil
        super.tearDown()
    }

    // MARK: - onProceed() routing branches

    func test_onProceed_rulesNotDefined_navigatesClose() {
        // Given
        viewModel.travelDocuments = makeDocs(
            citizenshipType: .rulesAreNotDefined
        )

        // When
        viewModel.onProceed()

        // Then
        XCTAssertEqual(router.lastNavigatedRoute, .close)
    }

    func test_onProceed_unknown_navigatesCitizenshipSelection() {
        // Given
        viewModel.travelDocuments = makeDocs(citizenshipType: .unknown)

        // When
        viewModel.onProceed()

        // Then
        XCTAssertEqual(router.lastNavigatedRoute, .citizenshipSelection)
    }

    func test_onProceed_stageWithChoices_navigatesDocumentTypeSelection() {
        // Given: first incomplete stage is choosable, not completed
        let stage = makeStage(isChoisable: true, isCompleted: false,
                              documents: [makeDoc()])
        viewModel.travelDocuments = makeDocs(
            citizenshipType: .known,
            stages: [stage]
        )

        // When
        viewModel.onProceed()

        // Then
        guard case .documentTypeSelection = router.lastNavigatedRoute else {
            return XCTFail("Expected .documentTypeSelection()")
        }
    }

    func test_onProceed_allStagesCompleted_withPostVoyage_navigatesPostVoyage() {
        // Given
        let stageCompleted = makeStage(isChoisable: false, isCompleted: true, documents: [])
        viewModel.travelDocuments = makeDocs(
            citizenshipType: .known,
            hasPostVoyagePlans: true,
            stages: [stageCompleted]
        )

        // When
        viewModel.onProceed()

        // Then
        XCTAssertEqual(router.lastNavigatedRoute, .postVoyagePlanes)
    }

    func test_onProceed_allStagesCompleted_noPostVoyage_navigatesReview() {
        // Given
        let st = makeStage(isChoisable: false, isCompleted: true, documents: [])
        viewModel.travelDocuments = makeDocs(
            citizenshipType: .known,
            hasPostVoyagePlans: false,
            stages: [st]
        )

        // When
        viewModel.onProceed()

        // Then
        XCTAssertEqual(router.lastNavigatedRoute, .documentReview)
    }

    func test_onProceed_nextDoc_capturable_navigatesScanPreparation() {
        // Given
        let doc = makeDoc(isCapturable: true)
        let stage = makeStage(isChoisable: false, isCompleted: false, documents: [doc])
        viewModel.travelDocuments = makeDocs(stages: [stage])

        // When
        viewModel.onProceed()

        // Then
        guard case let .documentScanPreparation(document: document, landing: _) = router.lastNavigatedRoute else {
            return XCTFail("Expected .documentScanPreparation for capturable doc")
        }
        XCTAssertTrue(document.isCapturable)
    }

    func test_onProceed_nextDoc_scanable_navigatesScanPreparation() {
        // Given
        let doc = makeDoc(isScanable: true)
        let stage = makeStage(isChoisable: false, isCompleted: false, documents: [doc])
        viewModel.travelDocuments = makeDocs(stages: [stage])

        // When
        viewModel.onProceed()

        // Then
        guard case let .documentScanPreparation(document: document, landing: _) = router.lastNavigatedRoute else {
            return XCTFail("Expected .documentScanPreparation for scanable doc")
        }
        XCTAssertTrue(document.isScanable)
    }

    func test_onProceed_nextDoc_twiceSide_navigatesScanPreparation() {
        // Given
        let doc = makeDoc(isCapturable: true, isScanable: true, isTwiceSide: true)
        let stage = makeStage(isChoisable: false, isCompleted: false, documents: [doc])
        viewModel.travelDocuments = makeDocs(stages: [stage])

        // When
        viewModel.onProceed()

        // Then
        guard case let .documentScanPreparation(document: document, landing: _) = router.lastNavigatedRoute else {
            return XCTFail("Expected .documentScanPreparation for two-side doc")
        }
        XCTAssertTrue(document.isTwiceSide)
    }

    func test_onProceed_nextDoc_declaration_navigatesDeclarationPreparation() {
        // Given: not uploaded, not capturable, not scanable, not twice side
        let doc = makeDoc()
        let stage = makeStage(isChoisable: false, isCompleted: false, documents: [doc])
        viewModel.travelDocuments = makeDocs(stages: [stage])

        // When
        viewModel.onProceed()

        // Then
        guard case let .documentDeclarationPreparation(document: document, landing: _) = router.lastNavigatedRoute else {
            return XCTFail("Expected .documentDeclarationPreparation")
        }
        XCTAssertFalse(document.isCapturable || document.isScanable || document.isTwiceSide)
    }

    // MARK: - onAppear() flows

    func test_onAppear_rulesNotDefined_setsContent_andNoNavigation() async {
        // Given
        getDocsUseCase.result = makeDocs(citizenshipType: .rulesAreNotDefined)

        // When
        await viewModel.onAppear()

        // Then
        XCTAssertEqual(viewModel.screenState, .content)
        XCTAssertNil(router.lastNavigatedRoute)
    }

    func test_onAppear_unknown_setsContent_andNoNavigation() async {
        // Given
        getDocsUseCase.result = makeDocs(citizenshipType: .unknown)

        // When
        await viewModel.onAppear()

        // Then
        XCTAssertEqual(viewModel.screenState, .content)
        XCTAssertNil(router.lastNavigatedRoute)
    }

    func test_onAppear_allStagesCompleted_withPostVoyage_navigatesPostVoyage() async {
        // Given
        let completed = makeStage(isChoisable: false, isCompleted: true, documents: [])
        getDocsUseCase.result = makeDocs(
            citizenshipType: .known,
            hasPostVoyagePlans: true,
            stages: [completed]
        )

        // When
        await viewModel.onAppear()

        // Then
        XCTAssertEqual(router.lastNavigatedRoute, .postVoyagePlanes)
    }

    func test_onAppear_allStagesCompleted_noPostVoyage_navigatesReview() async {
        // Given
        let completed = makeStage(isChoisable: false, isCompleted: true, documents: [])
        getDocsUseCase.result = makeDocs(
            citizenshipType: .known,
            hasPostVoyagePlans: false,
            stages: [completed]
        )

        // When
        await viewModel.onAppear()

        // Then
        XCTAssertEqual(router.lastNavigatedRoute, .documentReview)
    }

    func test_onAppear_someStageCompleted_andChoosableAvailable_navigatesDocTypeSelection() async {
        // Given: hasAnyStageCompleted == true, choosable stage exists and should not be skipped
        let completed = makeStage(isChoisable: false, isCompleted: true, documents: [])
        let choosable = makeStage(isChoisable: true, isCompleted: false, documents: [makeDoc()])
        getDocsUseCase.result = makeDocs(
            citizenshipType: .known,
            stages: [completed, choosable]
        )

        // When
        await viewModel.onAppear()

        // Then
        guard case let .documentTypeSelection(canNavigateBack) = router.lastNavigatedRoute else {
            return XCTFail("Expected .documentTypeSelection(false)")
        }
        XCTAssertFalse(canNavigateBack)
    }

    // MARK: - onClose

    func test_onClose_navigatesClose() {
        viewModel.onClose()
        XCTAssertEqual(router.lastNavigatedRoute, .close)
    }
}

// MARK: - Local Mocks

final class MockGetTravelDocumentsUseCase: GetTravelDocumentsUseCaseProtocol {
    var result: TravelDocuments?
    var shouldThrow = false

    func execute() async throws -> TravelDocuments {
        if shouldThrow { throw VVDomainError.genericError }
        return result ?? TravelDocuments.empty()
    }
}

// MARK: - Builders / Helpers
// Adjust these helpers to match your model factories if signatures differ.

private func makeDocs(
    citizenshipType: CitizenshipType = .known,
    hasPostVoyagePlans: Bool = false,
    stages: [TravelDocuments.DocumentStage] = []
) -> TravelDocuments {
    var docs = TravelDocuments.sample()
    docs.citizenshipType = citizenshipType
    docs.hasPostVoyagePlans = hasPostVoyagePlans
    docs.documentStages = stages
    return docs
}

private func makeStage(
    isChoisable: Bool,
    isCompleted: Bool,
    documents: [TravelDocuments.Document]
) -> TravelDocuments.DocumentStage {
    var s = TravelDocuments.DocumentStage(
        title: "Passport Scan",
        description: "It looks like there are multiple options for your primary document.",
        isChoisable: true,
        isCompleted: false,
        documents: [
            TravelDocuments.Document(
                name: "Passport",
                type: "passport",
                code: "P",
                categoryCode: "P",
                categoryId: "1",
                isScanable: true,
                isCapturable: false,
                isTwiceSide: false,
                isAlreadyUploaded: false,
                scanFormatType: .passportOrVisa,
                documentId: "",
                mrzField: .front,
                isMultiCategoryDocument: nil,
                categoryDetails: nil
            )
        ]
    )
    s.isChoisable = isChoisable
    s.isCompleted = isCompleted
    s.documents = documents
    return s
}

private func makeDoc(
    isAlreadyUploaded: Bool = false,
    isCapturable: Bool = false,
    isScanable: Bool = false,
    isTwiceSide: Bool = false
) -> TravelDocuments.Document {
    var d = TravelDocuments.Document(
        name: "Passport",
        type: "passport",
        code: "P",
        categoryCode: "P",
        categoryId: "1",
        isScanable: true,
        isCapturable: false,
        isTwiceSide: false,
        isAlreadyUploaded: false,
        scanFormatType: .passportOrVisa,
        documentId: "",
        mrzField: .front,
        isMultiCategoryDocument: nil,
        categoryDetails: nil
    )
    d.isCapturable = isCapturable
    d.isScanable = isScanable
    d.isTwiceSide = isTwiceSide
    return d
}

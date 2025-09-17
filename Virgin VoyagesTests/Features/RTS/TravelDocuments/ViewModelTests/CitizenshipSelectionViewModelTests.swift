//
//  CitizenshipSelectionViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.9.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class CitizenshipSelectionViewModelTests: XCTestCase {

    // SUT
    private var viewModel: CitizenshipSelectionViewModel!

    // Mocks
    private var router: TestNavigationRouter<TravelDocumentsRoute>!
    private var coordinator: TravelDocumentsCoordinator!
    private var saveUseCase: MockSaveCitizenshipUseCase!
    private var lookupUseCase: MockGetLookupUseCase!

    override func setUp() {
        super.setUp()

        router = TestNavigationRouter<TravelDocumentsRoute>()
        coordinator = TravelDocumentsCoordinator(navigationRouter: router)
        
        saveUseCase = MockSaveCitizenshipUseCase()
        lookupUseCase = MockGetLookupUseCase()

        viewModel = CitizenshipSelectionViewModel(
            coordinator: coordinator,
            saveCitizenshipUseCase: saveUseCase,
            getLookupUseCase: lookupUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        coordinator = nil
        router = nil
        saveUseCase = nil
        lookupUseCase = nil
        super.tearDown()
    }

    // MARK: - onAppear / loadLookupOptions

//    func test_onAppear_success_populatesCountries_andSetsContent() async {
//        // Given: mock lookup returns a countries list via toLookupOptionsDictionary()
//        lookupUseCase.lookupToReturn = makeLookupWithCountries(["AL":"Albania", "HK":"Hong Kong"])
//
//        // When
//        await viewModel.onAppear()
//
//        // Then
//        XCTAssertEqual(viewModel.screenState, .content)
//        XCTAssertEqual(viewModel.countries.count, 2)
//        XCTAssertTrue(viewModel.countries.contains(where: { $0.key == "AL" }))
//        XCTAssertTrue(viewModel.countries.contains(where: { $0.key == "HK" }))
//    }
//
//    func test_onAppear_whenLookupThrows_setsContent_andLeavesCountriesEmpty() async {
//        // Given
//        lookupUseCase.shouldThrow = true
//
//        // When
//        await viewModel.onAppear()
//
//        // Then
//        XCTAssertEqual(viewModel.screenState, .content)
//        XCTAssertTrue(viewModel.countries.isEmpty)
//    }
//
//    // MARK: - onProceed
//
//    func test_onProceed_withoutSelection_doesNotCallUseCase_orNavigate() async {
//        // Given
//        viewModel.selectedCountryCode = nil
//
//        // When
//        viewModel.onProceed()
//        await Task.yield()
//
//        // Then
//        XCTAssertEqual(saveUseCase.executeCallCount, 0)
//        XCTAssertNil(router.lastNavigatedRoute)
//    }
//
//    func test_onProceed_withSelection_callsUseCase_setsContent_andNavigates() async {
//        // Given
//        viewModel.selectedCountryCode = "HK"
//        saveUseCase.shouldSucceed = true
//        let exp = expectation(description: "use case executed")
//        saveUseCase.onExecute = { _ in exp.fulfill() }
//
//        // When
//        viewModel.onProceed()
//        await fulfillment(of: [exp], timeout: 1.0)
//
//        // Then
//        XCTAssertEqual(saveUseCase.executeCallCount, 1)
//        XCTAssertEqual(saveUseCase.lastInput?.citizenshipCountryCode, "HK")
//        XCTAssertEqual(viewModel.screenState, .content)
//
//        guard case let .documentTypeSelection(canNavigateBack) = router.lastNavigatedRoute else {
//            return XCTFail("Expected navigation to .documentTypeSelection(false)")
//        }
//        XCTAssertFalse(canNavigateBack)
//    }
//
//    func test_onProceed_whenUseCaseThrows_returnsToContent_andDoesNotNavigate() async {
//        // Given
//        viewModel.selectedCountryCode = "AL"
//        saveUseCase.shouldSucceed = false
//        saveUseCase.errorToThrow = VVDomainError.genericError
//        let exp = expectation(description: "use case executed")
//        saveUseCase.onExecute = { _ in exp.fulfill() }
//
//        // When
//        viewModel.onProceed()
//        await fulfillment(of: [exp], timeout: 1.0)
//        await Task.yield()
//
//        // Then
//        XCTAssertEqual(saveUseCase.executeCallCount, 1)
//        XCTAssertEqual(viewModel.screenState, .content)
//        XCTAssertNil(router.lastNavigatedRoute)
//    }
//
//    // MARK: - Binding
//
//    func test_selectedCountryBinding_readWrite() {
//        // Initially nil
//        XCTAssertNil(viewModel.selectedCountryCode)
//
//        // Write through binding
//        viewModel.selectedCountryBinding.wrappedValue = "US"
//        XCTAssertEqual(viewModel.selectedCountryCode, "US")
//
//        // Clear via binding to nil
//        viewModel.selectedCountryBinding.wrappedValue = nil
//        XCTAssertNil(viewModel.selectedCountryCode)
//    }
//
//    // MARK: - Back
//
//    func test_onBack_navigatesBack() {
//        viewModel.onBack()
//        XCTAssertTrue(router.navigateBackCalled)
//    }

    // MARK: - Helpers

    private func makeLookupWithCountries(_ map: [String:String]) -> Lookup {
        // Build a minimal Lookup containing only countries; other arrays empty
        let countries = map.map { Lookup.Country(name: $0.value, code: $0.key, threeLetterCode: "", dialingCode: "") }
        return Lookup(
            airlines: [], airports: [], cardTypes: [], cities: [],
            countries: countries,
            documentTypes: [], genders: [], languages: [], paymentModes: [],
            ports: [], rejectionReasons: [], relations: [], states: [],
            visaEntries: [], visaTypes: [], postCruiseAddressTypes: [],
            postCruiseTransportationOptions: [], documentCategories: []
        )
    }
}

// MARK: - Local Mocks (purely in-memory, no real calls)

final class MockSaveCitizenshipUseCase: SaveCitizenshipUseCaseProtocol {
    var executeCallCount = 0
    var lastInput: CitizenshipModel?
    var shouldSucceed = true
    var errorToThrow: Error = VVDomainError.genericError
    var onExecute: ((CitizenshipModel) -> Void)?

    func execute(input: CitizenshipModel) async throws -> EmptyResponse {
        executeCallCount += 1
        lastInput = input
        onExecute?(input)
        if shouldSucceed { return EmptyResponse() }
        throw errorToThrow
    }
}

final class MockGetLookupUseCase: GetLookupUseCaseProtocol {
    var shouldThrow = false
    var lookupToReturn: Lookup = .empty()

    func execute() async throws -> Lookup {
        if shouldThrow { throw VVDomainError.genericError }
        return lookupToReturn
    }
}

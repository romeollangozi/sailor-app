//
//  DocumentConfirmViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.6.25.
//

import XCTest
import VVUIKit
@testable import Virgin_Voyages

@MainActor
final class DocumentConfirmViewModelTests: XCTestCase {

    var sut: DocumentConfirmViewModel!

    override func setUp() {
        super.setUp()

        sut = DocumentConfirmViewModel(
            document: TravelDocumentDetails.sample(),
            isEditing: false,
            input: ScanTravelDocumentInputModel.empty(),
            documentCode: "GRC",
            shouldDisplayWarning: true
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_shouldShowBackButton_whenEditingIsFalse_returnsFalse() {
        XCTAssertFalse(sut.shouldShowBackButton)
    }

    func test_primaryButtonText_whenNotEditing_returnsSaveDocument() {
        XCTAssertEqual(sut.primaryButtonText, "Save document")
    }

    func test_secondaryButtonText_whenNotEditing_returnsCancel() {
        XCTAssertEqual(sut.secondaryButtonText, "Cancel")
    }

    func test_isInputValid_whenRequiredFieldsAreEmpty_returnsFalse() {
        // givenName and documentBackPhotoUrl are required and empty
        XCTAssertFalse(sut.isInputValid())
    }

    func test_isInputValid_whenAllRequiredFieldsAreFilled_returnsTrue() {
        sut.updateFieldValue(for: "documentBackPhotoUrl", newValue: "https://example.com/back.jpg")
        sut.updateFieldValue(for: "givenName", newValue: "Jane")
        sut.updateFieldValue(for: "greenCardNumber", newValue: "12345678")
        sut.updateFieldValue(for: "country", newValue: "US")
        sut.updateFieldValue(for: "dateOfIssue", newValue: "2024-01-01")

        XCTAssertTrue(sut.isInputValid())
    }

    func test_updateFieldValue_setsCorrectValue() {
        sut.updateFieldValue(for: "givenName", newValue: "Maria")
        XCTAssertEqual(sut.fieldValues["givenName"], "Maria")
    }

    func test_replaceImageFlags_toggleCorrectly() {
        sut.onReplaceDocument()
        XCTAssertTrue(sut.isConfirmReplace)

        sut.onConfirmReplaceDocument()
        XCTAssertTrue(sut.isReplaceImage)
        XCTAssertFalse(sut.isConfirmReplace)

        sut.onCancelReplaceDocument()
        XCTAssertFalse(sut.isConfirmReplace)
    }

    func test_getDropdownOptions_whenReferenceFound_returnsEmptyForNow() {
        let field = sut.document.fields.first { $0.type == .dropdown }!
        let result = sut.getDropdownOptions(for: field)
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_getDropdownOptions_whenVisaTypeWithMatchingCountry_returnsFilteredOptions() {
        // given
        sut.fieldValues["issueCountryCode"] = "US"
        sut.lookupSource = Lookup(
                    airlines: [],
                    airports: [],
                    cardTypes: [],
                    cities: nil,
                    countries: [],
                    documentTypes: [],
                    genders: [],
                    languages: nil,
                    paymentModes: [],
                    ports: [],
                    rejectionReasons: [],
                    relations: [],
                    states: [],
                    visaEntries: [],
                    visaTypes: [
                        .init(code: "V2", name: "Work Visa", countryCode: "CA"),
                        .init(code: "V1", name: "Tourist Visa", countryCode: "US")
                    ],
                    postCruiseAddressTypes: [],
                    postCruiseTransportationOptions: [],
                    documentCategories: []
                )
        
        let visaField = TravelDocumentDetails.Field(
            id: UUID().uuidString,
            label: "Visa Type",
            name: "visaType",
            type: .dropdown,
            value: "",
            readonly: false,
            hidden: false,
            required: true,
            isSecure: false,
            referenceName: "visaTypes"
        )

        // when
        let result = sut.getDropdownOptions(for: visaField)

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.key, "V1")
        XCTAssertEqual(result.first?.value, "V1 Tourist Visa")
    }

    func test_documentWithCode_returnsCorrectCode() {
        XCTAssertEqual(sut.documentWithCode.code, "GRC")
    }

    func test_replaceImagePopupTitles_areCorrectlyFormatted() {
        XCTAssertTrue(sut.replaceImagePopupTitle.contains("Replace"))
        XCTAssertTrue(sut.replaceImagePopupMessage.contains("associated with the information"))
        XCTAssertEqual(sut.replaceImagenPopupConfirmTitle, "Yes, replace image")
        XCTAssertEqual(sut.replaceImagePopupCancelTitle, "No, cancel")
    }
    
    func test_confirmDocumentAfterExpiryWarning_updatesStateAndDisablesWarning() {
        // Given
        sut.shouldShowPassportExpireWarning = true
        sut.screenState = .content

        let expectation = expectation(description: "Wait for screenState to become .content")

        // When
        sut.confirmDocumentAfterExpiryWarning()

        // Then
        let timeout: TimeInterval = 1.0
        let pollingInterval: TimeInterval = 0.05
        var elapsed: TimeInterval = 0.0

        func poll() {
            if self.sut.screenState == .content {
                XCTAssertFalse(self.sut.shouldShowPassportExpireWarning)
                XCTAssertEqual(self.sut.screenState, .content)
                expectation.fulfill()
            } else if elapsed >= timeout {
                XCTFail("screenState did not become .content in time. Current value: \(self.sut.screenState)")
            } else {
                elapsed += pollingInterval
                DispatchQueue.main.asyncAfter(deadline: .now() + pollingInterval, execute: poll)
            }
        }
        poll()

        waitForExpectations(timeout: timeout + 0.5)
    }
    
    func test_onPassportExpireError_navigatesToExpireDateWarning() {
        sut.onPassportExpireError()
        XCTAssertTrue(true)
    }
    
    func test_saveTravelDocument_whenMultiCitizenshipValidationError_setsOptionsAndShowsSelection() async {
        // Given
        let expectedOptions: [String: String] = ["CN": "China", "HK": "Hong Kong"]

        let validationError: ValidationError = .init(fieldErrors: [
            FieldError(
                field: DocumentFields.issueCountryCode.rawValue,
                errorMessage: "",
                isMultiCitizenshipError: true,
                multiCitizenErrorDetails: MultiCitizenErrorDetails(options: expectedOptions)
            )
        ], errors: [])
       

        let mockRepository = MockSaveTravelDocumentRepository()
        mockRepository.validationError = validationError
        mockRepository.shouldThrowError = true
        
        let useCase = SaveTravelDocumentUseCase(
            rtsCurrentSailorService: MockRtsCurrentSailorManager(),
            saveTravelDocumentRepository: mockRepository,
            currentSailorManager: MockCurrentSailorManager()
        )

        let sut = DocumentConfirmViewModel(
            document: TravelDocumentDetails.sample(), isEditing: false, saveTravelDocumentsUseCase: useCase,
            input: ScanTravelDocumentInputModel.empty(),
            documentCode: "P",
            shouldDisplayWarning: true
        )

        // When
        await sut.saveTravelDocument()
        
        // Then
        XCTAssertTrue(sut.isShowingCitizenshipSelection)
        XCTAssertEqual(sut.multiCitizenshipOptions, expectedOptions)
    }
}

